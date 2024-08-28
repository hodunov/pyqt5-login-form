import logging

import sys
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import pyqtSlot, QObject, QUrl
from api import ConnectAPI
from functools import lru_cache


logging.basicConfig(
    level=logging.DEBUG, format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class Backend(QObject):
    def __init__(self):
        super().__init__()

    @pyqtSlot(str, str, str, bool, result=bool)
    def login(
        self,
        username: str,
        password: str,
        location: str,
        is_prod: bool = False,
    ) -> bool:
        logger.info(
            "Login attempt: Username: %s, Password: %s, Location: %s, Is Prod: %s",
            username,
            password,
            location,
            is_prod,
        )

        # TODO: Implement login logic
        return True

    @lru_cache()
    def get_cached_data(self, is_prod):
        """
        Caches the results of the fetch_locations() method for the given is_prod value
        """
        api_client = ConnectAPI()
        locations = api_client.fetch_locations(is_prod)
        logger.info("Fetched locations: %s, is_prod: %s", len(locations), is_prod)
        return [{"value": item["id"], "text": item["location"]} for item in locations]

    @pyqtSlot(bool)
    def on_radio_button_changed(self, is_prod: bool):
        """
        Called when the radio button is changed
        """
        logger.info("Radio button changed, is_prod: %s", is_prod)
        # Perform API call based on the selected option
        dropdown_values = self.get_cached_data(is_prod)
        # Update the dropdown in QML
        self.update_dropdown(dropdown_values)

    def update_dropdown(self, values):
        """Find the dropdown in QML and update its model"""
        dropdown = self.root.findChild(QObject, "locationComboBox")
        if dropdown is None:
            logger.error("Could not find locationComboBox in QML")
            return
        dropdown.setProperty("model", values)


def print_debug_info():
    import inspect
    from PyQt5 import Qt

    vers = [
        "%s = %s" % (k, v)
        for k, v in vars(Qt).items()
        if k.lower().find("version") >= 0 and not inspect.isbuiltin(v)
    ]
    print("\n".join(sorted(vers)))
    print("-" * 10, "\n")


if __name__ == "__main__":
    print_debug_info()

    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

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
