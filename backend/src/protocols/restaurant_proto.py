from uagents import Context, Model, Protocol
from datetime import datetime
import os,sys,uuid

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

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

@take_Orders.on_message(model=OrderDetails)
async def recieve_Orders(ctx:Context,sender:str,newOrders:OrderDetails):
    '''
    Function to receive orders from the customer agent
    '''
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

    else:
        res_message=f"We are really sorry!! Currently we are not accepting any orders"
        await ctx.send(CUST_ADDRESS,OrderRejection(message=res_message))
    
    ctx.logger.info(f"Final Bill: {final_bill}")

    




