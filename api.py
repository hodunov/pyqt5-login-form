import logging
import requests

from typing import Any
from urllib.parse import urljoin

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class BaseAPI:
    def build_url(self, base_url: str, endpoint: str) -> str:
        return urljoin(base_url, endpoint)

    def _make_request(
        self, method: str, url: str, data: dict[str, Any] | None = None
    ) -> requests.Response:
        try:
            response = requests.request(
                method,
                url,
                headers=self.headers,
                json=data,
                timeout=10,
            )
            response.raise_for_status()
        except requests.RequestException:
            return response
        else:
            return response

    def fetch_data(self, endpoint: str) -> list:
        response = self._make_request("GET", endpoint)
        return response.json() if response else []


class ConnectAPI(BaseAPI):
    def __init__(self, is_prod: bool = False) -> None:
        # https://ajaxsystems.atlassian.net/wiki/spaces/AUT/pages/2244445272/M11G+API+servers
        self.prod_api_url: str = "https://m11g.prod.ajax.systems/"
        self.debug_api_url: str = "https://m11g-x.stage.ajax.systems/"
        self.api_url = self.prod_api_url if is_prod else self.debug_api_url
        self.token: str
        self.headers = {
            "Content-Type": "application/json",
            "X-SoftVersion": "1.38.0",
            "X-RequestUUID": "LocalTesting",
            "accept": "application/json",
        }

    def post_login(self, username: str, password: str) -> str:
        data = {"username": username, "password": password}
        response = self._make_request("POST", "/core-db/api/v1/auth_api/", data)
        token_data = response.json()
        self.token = token_data.get("token", None)
        return token_data

    def fetch_locations(self, is_prod: bool = False) -> list:
        """
        Fetches all locations from the API
        """
        base_url = self.prod_api_url if is_prod else self.debug_api_url
        logger.info("Fetching locations from %s", base_url)
        url = self.build_url(base_url, "/core-db/api/v1/general/prod_location/")
        return self.fetch_data(url)
