from uagents import Context, Model, Protocol
from datetime import datetime
import os,sys,uuid,geocoder
from geopy.distance import geodesic

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))
from backend.src.utils.exception import customException

DEL_ADDRESS=os.getenv("DEL_ADDRESS")
CUST_ADDRESS=os.getenv("CUST_ADDRESS")

class OrderDetails(Model):
    location:list
    date:datetime
    restaurant:str
    order:list
    max_price:float

class OrderConfirmation(Model):
    orderID:str
    totalCost:float
    status:bool
    message:str

class OrderRejection(Model):
    message:str

class ValetMessage(Model):
    orderID:str
    userloc:list
    restaurantloc:list
    message:str
    totalCost:float

class ValetConfirm(Model):
    location:list
    message:str

class OrderPickupMessage(Model):
    deliveryPartner:str
    message:str

take_Orders=Protocol("Taking Orders")
get_valet=Protocol("Handling the Valet Agent")

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

@take_Orders.on_message(model=OrderDetails)
async def recieve_Orders(ctx:Context,sender:str,newOrders:OrderDetails):
    '''
    Function to receive orders from the customer agent
    '''
    rest_loc=agent_location()
    ctx.storage.set("location",rest_loc)
    ctx.logger.info(f"New Order received from address {sender}")
    orderID = str(uuid.uuid4())

    # Initialize lists to store dish names, descriptions, and item costs
    dish_names = []
    dish_descriptions = []
    item_costs = []

    # Loop through the dishes and append the values to the respective lists
    for dish in newOrders.order:
        try:
            dish_names.append(dish['itemname'])
        except:
            dish_names.append(dish['name'])
        dish_descriptions.append(dish['description'])
        item_costs.append(dish['itemcost'])
    
    #Logging the order details for the restuarant's reference
    ctx.logger.info(f"Order ID : {orderID}")
    ctx.logger.info(f"Customer location : {newOrders.location}")
    for i in range(len(dish_names)):
        #Display order details to the restuarant
        ctx.logger.info(f"{dish_names[i]} - {item_costs[i]}")
    ctx.logger.info(f"Total Cost: {newOrders.max_price}")
    
    extraPay=0.05*newOrders.max_price #takes into account, the delivery fee and the handling charges
    confirmation=1

    if confirmation:
        res_message=f"Thank you for choosing {newOrders.restaurant}. Your order will be delivered soon..."
        final_bill=newOrders.max_price + extraPay
        await ctx.send(CUST_ADDRESS,OrderConfirmation(orderID=orderID,totalCost=final_bill,status=confirmation,message=res_message))
        ctx.logger.info(f"Final Bill: {final_bill}")

        valetMessage="Order will be getting ready in few minutes..."

        await ctx.send(DEL_ADDRESS,ValetMessage(orderID=orderID,userloc=newOrders.location,restaurantloc=rest_loc,message=valetMessage,totalCost=final_bill))

    else:
        res_message=f"We are really sorry!! Currently we are not accepting any orders"
        await ctx.send(CUST_ADDRESS,OrderRejection(message=res_message))

@get_valet.on_message(model=ValetConfirm)
async def valet_confirm_message(ctx:Context, sender:str, valetmsg:ValetConfirm):
    ctx.logger.info(f"Valet Address: {valetmsg.location}")
    ctx.logger.info(f"Valet Message: {valetmsg.message}")

    cust_message=f"Valet Agent {sender} picked up the order and will be delivering it soon..."

    await ctx.send(CUST_ADDRESS,OrderPickupMessage(deliveryPartner=sender,message=cust_message))

    




