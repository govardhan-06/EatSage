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

class ReceiveOrders(Model):
    items:list
    qty:list
    itemCost:list
    totalCost:float

class OrderConfirmation(Model):
    orderID:str
    totalCost:float
    status:bool
    message:str

class DeliveryPartnerMessage(Model):
    orderID:str
    userloc:str
    restaurantloc:str
    message:str
    totalCost:str

class OrderPickupMessage(Model):
    deliveryPartner:str
    message:str

take_Orders=Protocol("Taking Orders")

@take_Orders.on_message(model=ReceiveOrders)
async def recieve_Orders(ctx:Context,sender:str,newOrders:ReceiveOrders):
    ctx.logger.info(f"New Order received from address {sender}")
    for i in range(len(newOrders.items)):
        ctx.logger.info(f"Item: {newOrders.items[i]} Quantity: {newOrders.qty[i]}")
    ctx.logger.info(f"Total Cost: {newOrders.totalCost}")
    return "Order Received"

restaurant.include(take_Orders)

if __name__=="__main__":
    restaurant.run()

