from uagents import Agent, Context, Model, Protocol
from ai_engine import UAgentResponse, UAgentResponseType
from uagents.setup import fund_agent_if_low

import os,sys
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

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

class Message(Model):
    msg:str

@restaurant.on_message(model=Message)
async def testMessage_customer(ctx:Context,sender:str,msg:Message):
    ctx.logger.info(f"Received message from {sender}: {msg.msg}")
    await ctx.send(DEL_ADDRESS,Message(msg="Order Prepared"))

if __name__=="__main__":
    restaurant.run()

