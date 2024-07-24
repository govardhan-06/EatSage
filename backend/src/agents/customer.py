from uagents import Agent, Context, Model, Protocol
from langchain_groq import ChatGroq
from langchain_core.messages import SystemMessage
from langchain_core.prompts import HumanMessagePromptTemplate, ChatPromptTemplate
from ai_engine import UAgentResponse, UAgentResponseType
from uagents.setup import fund_agent_if_low

import os,sys
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

from backend.src.contextLoader import contextLoader

load_dotenv()

GROQ_API_KEY=os.getenv("GROQ_API_KEY")
NAME=os.getenv("CUST_NAME")
SEED_PHRASE=os.getenv("CUST_SEED_PHRASE")
DEL_ADDRESS=os.getenv("DEL_ADDRESS")
RES_ADDRESS=os.getenv("RES_ADDRESS")

CUST_ADDRESS="agent1q0k2rwfj5up9s7z8896pyrchzqawdywcj4ua4vwhfdky0fstvvjtqu3f9kw"

class UserPrompt(Model):
    prompt:str

class aiResponse(Model):
    response:str

customer=Agent(
    name=NAME,
    port=8000,
    seed=SEED_PHRASE,
    endpoint=["http://127.0.0.1:8000/submit"]
)

fund_agent_if_low(customer.wallet.address())

makeOrder=Protocol("Make Orders")

@customer.on_interval(period=5.0)
async def startup(ctx:Context):
    await ctx.send(CUST_ADDRESS,UserPrompt(prompt="Hey, I need some non veg dishes for my dinner"))

@makeOrder.on_message(model=UserPrompt,replies=aiResponse)
async def Prompt(ctx:Context,sender:str,p:UserPrompt):
    context=contextLoader()
    llm=ChatGroq(temperature=0,model="llama3-70b-8192",api_key=GROQ_API_KEY)
    chat_template = ChatPromptTemplate.from_messages(
    [
        SystemMessage(
            content=(
                "You are a friendly health assistant, who helps users to find the perfect food items based on their specific needs and preferences. "
                "You must suggest delicious and nutritious options to keep them feeling their best. "
                "Also, try to club the food suggestions from a single restaurant. Pick out the best options rather than suggesting food items from all the restaurants. "
                "The output must be in JSON format. You must answer in this format: "
                '{"Restaurant" : <value>, "Dishes" :["itemname": <value>,"description": <value>,"itemcost": <value>]}'
                "The output must be a proper meal rather than a list of dishes from the available restaurant."
                "Strictly, stick to the provided context"
                f" Use this context to suggest the food items and restaurant: {context}"
            )
        ),
        HumanMessagePromptTemplate.from_template("{text}"),
    ]
    )
    chain_suggest = chat_template | llm
    llmOutput = chain_suggest.invoke({"text": p.prompt})

    response_modifier_template = ChatPromptTemplate.from_messages(
    [
        SystemMessage(
            content=(
                "You are a helpful chat assistant."
                "You must extract neccessary information from the given prompt like Restaurant name, Dish name, Description and price."
                "The output must be a JSON"
                "Follow this format: "
                '{"Restaurant" : <value>, "Dishes" :["itemname": <value>,"description": <value>,"itemcost": <value>]}'
                "The '<value> spaces must be filled with the appropriate data from the given prompt"
            )
        ),
        HumanMessagePromptTemplate.from_template("{text}"),
    ]
    )

    chain_modifier= response_modifier_template | llm
    llmOutput=chain_modifier.invoke({"text":llmOutput.content})
    ctx.logger.info(llmOutput)
    
customer.include(makeOrder)

if __name__=="__main__":
    customer.run()

