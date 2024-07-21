from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv
import os,sys
from dataclasses import dataclass
from backend.src.utils.exception import customException
from backend.src.utils.logger import logging

load_dotenv()

@dataclass
class MongoDBConfig:
    uri = os.getenv("MONGO_DB_URI")
    logging.info("Mongo DB Credentials retrieved")

class MongoDB:
    def __init__(self):
        # Create a new client and connect to the server
        logging.info("Mongo DB client created")
        self.client = MongoClient(MongoDBConfig.uri, server_api=ServerApi('1'))
    
    def ping(self):
        # Send a ping to confirm a successful connection
        try:
            logging.info("Verifying mongo db connection")
            self.client.admin.command('ping')
            print("Pinged your deployment. You successfully connected to MongoDB!")
        except Exception as e:
            logging.error(e)
            raise customException(e,sys)

if __name__=="__main__":
    mongo = MongoDB()
    mongo.ping()