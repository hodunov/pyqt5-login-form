import logging

import sys
from PyQt5.QtWidgets import QApplication, QMessageBox
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import pyqtSlot, QObject, QUrl, pyqtSignal
from api import AjaxAPIClient, APIError
from functools import lru_cache


logging.basicConfig(
    level=logging.DEBUG, format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class Backend(QObject):
    dropdownUpdated = pyqtSignal(list)

    def __init__(self):
        super().__init__()
        self.is_logging_in = False  # Flag to prevent multiple logins
        self.token = None

    @pyqtSlot(str, str, str, bool, result=bool)
    def login(
        self,
        username: str,
        password: str,
        location: str,
        is_prod: bool = False,
    ) -> bool:
        if self.is_logging_in:
            return False

        if self.token:
            logger.info("Already logged in")
            return True

        self.is_logging_in = True
        logger.info(
            "Login attempt: Username: %s, Password: %s, Location: %s, Is Prod: %s",
            username,
            password,
            location,
            is_prod,
        )

        try:
            api_client = AjaxAPIClient(is_prod=is_prod)
            response = api_client.login(username, password, is_prod, location)
            logger.info("Login response: %s", response)
            self.token = response.get("token", None)
        except (APIError, AttributeError) as e:
            logger.error("Login failed: %s", e)
            self.token = None
            return False
        finally:
            self.is_logging_in = False

        return bool(self.token)

    @lru_cache()
    def get_cached_data(self, is_prod):
        """
        Caches the results of the fetch_locations() method for the given is_prod value
        """
        api_client = AjaxAPIClient(is_prod)
        locations = api_client.fetch_locations()
        logger.info("Fetched locations: %s, is_prod: %s", len(locations), is_prod)
        return [{"value": item["id"], "text": item["location"]} for item in locations]

    def on_radio_button_changed(self, is_prod: bool):
        """
        Called when the radio button is changed
        """
        db_type = "production" if is_prod else "debug_production"
        logger.info("Database button changed to %s", db_type)
        # Perform API call based on the selected option
        dropdown_values = self.get_cached_data(is_prod)
        self.dropdownUpdated.emit(dropdown_values)


def handle_exception(exc_type, exc_value, exc_traceback):
    QMessageBox.critical(None, "Unhandled Exception", f"An error occurred: {exc_value}")


if __name__ == "__main__":
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    sys.excepthook = handle_exception

    backend = Backend()
    engine.rootContext().setContextProperty("backend", backend)
    engine.load(QUrl("main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)

    backend.root = engine.rootObjects()[0]
    backend.root.radioButtonChanged.connect(backend.on_radio_button_changed)
    # Get data and prefill the dropdown with locations
    backend.on_radio_button_changed(False)
    backend.on_radio_button_changed(True)

    sys.exit(app.exec_())
