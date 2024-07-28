from uagents import Agent, Context, Model, Protocol
from uagents.setup import fund_agent_if_low

'''
This script is used to test the functionality of the entire application
'''

import os,sys
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

load_dotenv()

DEL_ADDRESS=os.getenv("DEL_ADDRESS")
RES_ADDRESS=os.getenv("RES_ADDRESS")
CUST_ADDRESS=os.getenv("CUST_ADDRESS")

class UserPrompt(Model):
    prompt:str

master=Agent(
    name="Master",
    port=8005,
    seed="Test",
    endpoint=["http://127.0.0.1:8005/submit"],
)

fund_agent_if_low(master.wallet.address())

@master.on_interval(period=3.0)
async def send_message(ctx:Context):
    await ctx.send(CUST_ADDRESS,UserPrompt(prompt="I am diabetic, suggest something for dinner"))

if __name__=="__main__":
    master.run()

