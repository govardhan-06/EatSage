from langchain_community.document_loaders import JSONLoader
import json
from pathlib import Path
from pprint import pprint
from dataclasses import dataclass

@dataclass
class RestaurantDataConfig:
    """Configuration for the restaurant data loader."""
    file_path='./backend/src/restaurantData/restaurants.json'

class RestaurantData:
    """Class for loading restaurant data from a JSON file."""
    def __init__(self):
        self.config = RestaurantDataConfig()
    
    def load_data(self):
        """Loads the restaurant data from the JSON file."""
        loader = JSONLoader(
            file_path=self.config.file_path,
            jq_schema='.data.Menu[]',
            text_content=False)

        data = loader.load()
        return data

if __name__=="__main__":
    r = RestaurantData()
    data=r.load_data()
    pprint(data)