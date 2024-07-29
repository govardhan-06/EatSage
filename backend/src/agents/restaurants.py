from uagents import Agent
from uagents.setup import fund_agent_if_low
from datetime import datetime

import os,sys
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))
from backend.src.protocols.restaurant_proto import take_Orders

load_dotenv()

NAME=os.getenv("RES_NAME")
SEED_PHRASE=os.getenv("RES_SEED_PHRASE")
DEL_ADDRESS=os.getenv("DEL_ADDRESS")
CUST_ADDRESS=os.getenv("CUST_ADDRESS")

restaurant=Agent(
    name=NAME,
    port=8001,
    seed=SEED_PHRASE,
    endpoint=["http://127.0.0.1:8001/submit"]
)

fund_agent_if_low(restaurant.wallet.address())

restaurant.include(take_Orders,publish_manifest=True)

if __name__=="__main__":
    restaurant.run()

