import os, sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

from backend.src.triggers.customerAgent import customer_initiator
import requests
from dotenv import load_dotenv

load_dotenv()

class Customer:
    def __init__(self):
        customer_initiator()
        self.MASTERKEY=os.getenv("EATSAGE_MASTERKEY")
        self.EMAIL_ADDRESS=os.getenv("USER_EMAIL_ADDRESS")
    
    def initate_session(self):
        data = {
            "email": self.EMAIL_ADDRESS,
            "requestedModel": "talkative-01",
        }

        session_details=requests.post("https://agentverse.ai/v1beta1/engine/chat/sessions", json=data, headers={
            f"Authorization": "bearer {self.MASTERKEY}"
        })

        self.sessionID=session_details[0]['session_id']

    def initiate_pipeline(self,prompt):
        """
        This function initiates the pipeline for the customer
        """
        data = {
            "payload": {
                "type": "start",
                f"objective": {prompt},
                "context": "User full Name: Test User\nUser email: user@user.com\n"    #Test user data
            }
        }

        pathParameters = {
            "session_id": self.sessionID
        }

        requests.post(f"https://agentverse.ai/v1beta1/engine/chat/sessions/{pathParameters['session_id']}/submit", json=data, headers={
            f"Authorization": "bearer {self.MASTERKEY}"
        })
    
    
        
