from uagents import Context, Model, Protocol
import os,sys,geocoder

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))
from backend.src.utils.exception import customException

CUST_ADDRESS=os.getenv("CUST_ADDRESS")
RES_ADDRESS=os.getenv("RES_ADDRESS")

class ValetMessage(Model):
    orderID:str
    userloc:list
    restaurantloc:list
    message:str
    totalCost:float

class ValetConfirm(Model):
    location:list
    message:str

get_Calls=Protocol("Getting orders from the restaurant agent",version="1.0")
initiate_payment=Protocol("Initiate Bill Payment",version="1.0")
confirm_pay=Protocol("Confirm payment",version="1.0")

def agent_location() -> list:
    '''
    This function returns the location of the agent using IP address.
    '''
    try:
        g = geocoder.ip('me')
 
        agent_loc = g.latlng
    except Exception as e:
        raise customException(e,sys)

    return agent_loc

@get_Calls.on_message(model=ValetMessage,replies=ValetConfirm)
async def recieve_delivery_orders(ctx:Context,sender:str,newCall:ValetMessage):
    '''
    Function to receive orders from the restaurant agent
    '''
    valet_loc=agent_location()
    ctx.storage.set("location",valet_loc)
    ctx.logger.info(f"New Delivery call received from address {sender}")

    #Log the information for valet's reference
    ctx.logger.info(f"Order ID: {newCall.orderID}")
    ctx.logger.info(f"Delivery Coordinates: {newCall.userloc}")
    ctx.logger.info(f"Restaurant Coordinates: {newCall.restaurantloc}")
    ctx.logger.info(f"Message: {newCall.message}")
    ctx.logger.info(f"Total Bill: {newCall.totalCost}")

    confirmation=1

    if confirmation:
        val_message=f"Received your delivery call. My current location: {valet_loc}. Picking up the order in few minutes..."
        await ctx.send(RES_ADDRESS,ValetConfirm(location=valet_loc,message=val_message))

    else:
        val_message=f"Sorry!! currently not ready to deliver the orders"
        await ctx.send(RES_ADDRESS,ValetConfirm(location=valet_loc,message=val_message))






