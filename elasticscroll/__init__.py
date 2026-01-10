"""ElasticScroll - Minimal library for efficient elasticsearch queries."""

from typing import Dict, Iterator, Any, Optional, Union
import logging

try:
    import elasticsearch
    # Handle different exception naming across elasticsearch versions
    try:
        from elasticsearch.exceptions import ElasticsearchException
    except ImportError:
        # In newer versions, use TransportError as base exception
        from elasticsearch.exceptions import TransportError as ElasticsearchException
except ImportError as e:
    raise ImportError(
        "elasticsearch package is required. Install it with: pip install elasticsearch"
    ) from e

__version__ = "0.1.0"
__all__ = ["ElasticMinimal"]

# Configure module logger
logger = logging.getLogger(__name__)


class ElasticMinimal:
    """Minimal Elasticsearch client for efficient scroll queries.
    
    This class provides a simple interface for executing scroll queries
    against Elasticsearch indices, yielding results efficiently.
    
    Attributes:
        endpoint: The Elasticsearch API endpoint URL.
        es_client: The underlying Elasticsearch client instance.
    """

    def __init__(self, elastic_endpoint: str) -> None:
        """Initialize the ElasticMinimal client.

        Args:
            elastic_endpoint: A URL corresponding to the API endpoint 
                of the elasticsearch service (e.g., 'http://localhost:9200').

        Raises:
            ValueError: If elastic_endpoint is empty or invalid.
            ElasticsearchException: If connection to Elasticsearch fails.
        """
        if not elastic_endpoint or not isinstance(elastic_endpoint, str):
            raise ValueError(
                "elastic_endpoint must be a non-empty string"
            )
        
        self.endpoint = elastic_endpoint
        try:
            self.es_client = elasticsearch.Elasticsearch(elastic_endpoint)
            # Test connection
            if not self.es_client.ping():
                logger.warning(
                    "Elasticsearch endpoint %s is not responding to ping",
                    elastic_endpoint
                )
        except ElasticsearchException as e:
            logger.error(
                "Failed to connect to Elasticsearch at %s: %s",
                elastic_endpoint, str(e)
            )
            raise

    def scroll_query(
        self,
        index: str,
        lookup: Dict[str, Any],
        size: int = 10,
        scroll: str = '2m'
    ) -> Iterator[Dict[str, Any]]:
        """Execute a scroll query and yield results.

        This method performs a scroll query on the specified index and yields
        the source documents one at a time. It handles pagination automatically
        using the Elasticsearch scroll API.

        Args:
            index: The name of the index to query.
            lookup: The elasticsearch query as a dictionary (e.g., 
                {'query': {'match_all': {}}}).
            size: Number of results to return per page. Defaults to 10.
            scroll: Time to keep the scroll context alive (e.g., '2m', '1h').
                Defaults to '2m'.

        Yields:
            dict: The _source field of each document matching the query.

        Raises:
            ValueError: If index or lookup are invalid.
            ElasticsearchException: If the query fails or scroll context expires.

        Example:
            >>> esm = ElasticMinimal('http://localhost:9200')
            >>> query = {'query': {'match_all': {}}}
            >>> for doc in esm.scroll_query('my_index', query):
            ...     print(doc)
        """
        # Input validation
        if not index or not isinstance(index, str):
            raise ValueError("index must be a non-empty string")
        
        if not lookup or not isinstance(lookup, dict):
            raise ValueError("lookup must be a non-empty dictionary")
        
        if not isinstance(size, int) or size <= 0:
            raise ValueError("size must be a positive integer")
        
        if not isinstance(scroll, str) or not scroll:
            raise ValueError("scroll must be a non-empty string")

        sid = None  # Initialize scroll ID for cleanup in finally block
        try:
            # Initial search request
            logger.debug(
                "Starting scroll query on index '%s' with size=%d, scroll=%s",
                index, size, scroll
            )
            page = self.es_client.search(
                index=index,
                scroll=scroll,
                size=size,
                body=lookup
            )
            
            sid = page['_scroll_id']
            
            # Handle both old and new elasticsearch response formats
            # Elasticsearch 7.x returns a dict, 8.x may return an int
            total_hits = page['hits']['total']
            if isinstance(total_hits, dict):
                scroll_size = total_hits['value']
            else:
                scroll_size = total_hits
            
            logger.debug("Total hits: %d", scroll_size)
            results_count = 0

            # Process initial batch of results
            for res in page['hits']['hits']:
                results_count += 1
                yield res['_source']

            # Scroll through remaining results
            scroll_size = len(page['hits']['hits'])
            while scroll_size > 0:
                page = self.es_client.scroll(scroll_id=sid, scroll=scroll)
                sid = page['_scroll_id']
                scroll_size = len(page['hits']['hits'])

                for res in page['hits']['hits']:
                    results_count += 1
                    yield res['_source']
            
            logger.debug("Scroll query completed. Yielded %d results", results_count)

        except ElasticsearchException as e:
            logger.error(
                "Elasticsearch error during scroll query on index '%s': %s",
                index, str(e)
            )
            raise
        except KeyError as e:
            logger.error(
                "Unexpected response format from Elasticsearch: missing key %s",
                str(e)
            )
            raise
        finally:
            # Clear the scroll context to free resources
            if sid:
                try:
                    self.es_client.clear_scroll(scroll_id=sid)
                    logger.debug("Cleared scroll context")
                except Exception as e:
                    logger.warning(
                        "Failed to clear scroll context: %s", str(e)
                    )