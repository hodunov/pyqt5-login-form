import os
import logging
import requests

from typing import Any, Optional, Union
from urllib.parse import urljoin
from dotenv import load_dotenv

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


# load environment variables
load_dotenv()


class APIConfig:
    PROD_API_URL = os.getenv("PROD_API_URL", default="https://example.com/api/")
    DEBUG_API_URL = os.getenv("DEBUG_API_URL", default="https://example.com/api/")
    DEFAULT_HEADERS = {
        "Content-Type": "application/json",
        "X-SoftVersion": "1.38.0",
        "X-RequestUUID": "LocalTesting",
        "accept": "application/json",
    }
    TIMEOUT = 10


class APIError(Exception):
    def __init__(self, message: str, response: Optional[requests.Response] = None):
        self.message = message
        self.response = response
        super().__init__(self.message)


class BaseAPIClient:
    def __init__(self, is_prod: bool = False):
        self.base_url = APIConfig.PROD_API_URL if is_prod else APIConfig.DEBUG_API_URL
        self.headers = APIConfig.DEFAULT_HEADERS.copy()

    @staticmethod
    def build_url(base_url: str, endpoint: str) -> str:
        return urljoin(base_url, endpoint)

    def _make_request(
        self, method: str, endpoint: str, data: Optional[dict[str, Any]] = None
    ) -> requests.Response:
        url = self.build_url(self.base_url, endpoint)
        try:
            response = requests.request(
                method,
                url,
                headers=self.headers,
                json=data,
                timeout=APIConfig.TIMEOUT,
            )
            if response and response.status_code not in [200, 400]:
                response.raise_for_status()
            return response
        except requests.RequestException as e:
            logger.error("API request failed %s", str(e))
            raise APIError(
                f"API request failed: {e}", response=getattr(e, "response", None)
            )

    def fetch_data(self, endpoint: str) -> Union[list, dict]:
        response = self._make_request("GET", endpoint)
        try:
            return response.json()
        except ValueError:
            logger.error("Failed to parse JSON response")
            raise APIError("Failed to parse JSON response", response=response)


class AjaxAPIClient(BaseAPIClient):
    def __init__(self, is_prod: bool = False):
        self.base_url = APIConfig.PROD_API_URL if is_prod else APIConfig.DEBUG_API_URL
        self.headers = APIConfig.DEFAULT_HEADERS.copy()

    def login(self, username: str, password: str, *args, **kwargs) -> dict:
        data = {"username": username, "password": password}
        response = self._make_request("POST", "/core-db/api/v1/auth_api/", data)
        try:
            return response.json()
        except ValueError:
            logger.error("Failed to parse JSON response from login")
            raise APIError(
                "Failed to parse JSON response from login", response=response
            )

    def fetch_locations(self) -> list:
        logger.info(f"Fetching locations from {self.base_url}")
        return self.fetch_data("/core-db/api/v1/general/prod_location/")
