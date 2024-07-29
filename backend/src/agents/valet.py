from uagents import Agent
from uagents.setup import fund_agent_if_low

import os,sys
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))
from backend.src.protocols.valet_proto import get_Calls

load_dotenv()

NAME=os.getenv("DEL_NAME")
SEED_PHRASE=os.getenv("DEL_SEED_PHRASE")
DEL_ADDRESS=os.getenv("DEL_ADDRESS")
CUST_ADDRESS=os.getenv("CUST_ADDRESS")

valet=Agent(
    name=NAME,
    port=8002,
    seed=SEED_PHRASE,
    endpoint=["http://127.0.0.1:8002/submit"]
)

fund_agent_if_low(valet.wallet.address())

valet.include(get_Calls,publish_manifest=True)

if __name__=="__main__":
    valet.run()

