from uagents import Agent, Context, Model, Protocol
from ai_engine import UAgentResponse, UAgentResponseType
from uagents.setup import fund_agent_if_low

import os,sys
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

load_dotenv()

NAME=os.getenv("DEL_NAME")
SEED_PHRASE=os.getenv("DEL_SEED_PHRASE")
DEL_ADDRESS=os.getenv("DEL_ADDRESS")
CUST_ADDRESS=os.getenv("CUST_ADDRESS")

delivery=Agent(
    name=NAME,
    port=8002,
    seed=SEED_PHRASE,
    endpoint=["http://127.0.0.1:8002/submit"]
)

fund_agent_if_low(delivery.wallet.address())

class Message(Model):
    msg:str

@delivery.on_message(model=Message)
async def testMessage_customer(ctx:Context,sender:str,msg:Message):
    ctx.logger.info(f"Received message from {sender}: {msg.msg}")
    await ctx.send(CUST_ADDRESS,Message(msg="Order Delivery"))

if __name__=="__main__":
    delivery.run()

