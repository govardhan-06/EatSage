from uagents import Agent
from uagents.setup import fund_agent_if_low

import os,sys
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

from backend.src.protocols.customer_proto import makeOrder

load_dotenv()

NAME=os.getenv("CUST_NAME")
SEED_PHRASE=os.getenv("CUST_SEED_PHRASE")
DEL_ADDRESS=os.getenv("DEL_ADDRESS")
RES_ADDRESS=os.getenv("RES_ADDRESS")
MAILBOX=os.getenv("CUST_MAILBOX")

customer=Agent(
    name=NAME,
    port=8000,
    seed=SEED_PHRASE,
    endpoint=["http://127.0.0.1:8000/submit"],
    mailbox=MAILBOX
)

fund_agent_if_low(customer.wallet.address())

customer.include(makeOrder,publish_manifest=True)

if __name__=="__main__":
    customer.run()

