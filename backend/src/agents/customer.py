from uagents import Agent, Context, Model, Protocol
from langchain_groq import ChatGroq
from langchain_core.messages import SystemMessage
from langchain_core.prompts import HumanMessagePromptTemplate
from ai_engine import UAgentResponse, UAgentResponseType
from uagents.setup import fund_agent_if_low

import os,sys
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

load_dotenv()

GROQ_API_KEY=os.getenv("GROQ_API_KEY")
NAME=os.getenv("CUST_NAME")
SEED_PHRASE=os.getenv("CUST_SEED_PHRASE")
DEL_ADDRESS=os.getenv("DEL_ADDRESS")
RES_ADDRESS=os.getenv("RES_ADDRESS")

class UserPrompt(Model):
    prompt:str

class Message(Model):
    msg:str

customer=Agent(
    name=NAME,
    port=8000,
    seed=SEED_PHRASE,
    endpoint=["http://127.0.0.1:8000/submit"]
)

fund_agent_if_low(customer.wallet.address())

@customer.on_interval(period=5.0)
async def send_message(ctx:Context):
    await ctx.send(RES_ADDRESS,Message(msg="Order Confirmed"))

@customer.on_message(model=Message)
async def testMessage_customer(ctx:Context,sender:str,msg:Message):
    ctx.logger.info(f"Received message from {sender}: {msg.msg}")
    await ctx.send(DEL_ADDRESS,Message(msg="Thank You"))

if __name__=="__main__":
    print(RES_ADDRESS)
    customer.run()

