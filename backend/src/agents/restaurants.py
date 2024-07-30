from uagents import Agent,Context,Model
from uagents.network import wait_for_tx_to_complete
from uagents.setup import fund_agent_if_low

import os,sys
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))
from backend.src.protocols.restaurant_proto import take_Orders,get_valet

load_dotenv()

NAME=os.getenv("RES_NAME")
SEED_PHRASE=os.getenv("RES_SEED_PHRASE")
DEL_ADDRESS=os.getenv("DEL_ADDRESS")
CUST_ADDRESS=os.getenv("CUST_ADDRESS")

restaurant=Agent(
    name=NAME,
    port=8002,
    seed=SEED_PHRASE,
    endpoint=["http://127.0.0.1:8002/submit"],
)

fund_agent_if_low(restaurant.wallet.address())

restaurant.include(take_Orders,publish_manifest=True)
restaurant.include(get_valet,publish_manifest=True)

class PaymentRequest(Model):
    wallet_address: str
    amount: int
    denom: str
 
class TransactionInfo(Model):
    tx_hash: str
    amount:str
    denom:str

class TransactionStatus(Model):
    status:str

@restaurant.on_message(model=TransactionStatus)
async def request_bill_payment(ctx: Context,sender:str,TransactionStatus:str):
    AMOUNT=100
    DENOM="atestfet"
    await ctx.send(DEL_ADDRESS,PaymentRequest(wallet_address=str(restaurant.wallet.address()), amount=AMOUNT, denom=DENOM))

@restaurant.on_message(model=TransactionInfo)
async def confirm_transaction(ctx: Context, sender: str, msg: TransactionInfo):
    ctx.logger.info(f"Received transaction info from {sender}: {msg}")
 
    tx_resp = await wait_for_tx_to_complete(msg.tx_hash, ctx.ledger)
    coin_received = tx_resp.events["coin_received"]
 
    if (
        coin_received["receiver"] == str(restaurant.wallet.address())
        and coin_received["amount"] == f"{msg.amount}{msg.denom}"
    ):
        ctx.logger.info(f"Transaction was successful: {coin_received}")

        await ctx.send(CUST_ADDRESS,TransactionStatus(status="Transaction successfull!! Thank you."))
        await ctx.send(DEL_ADDRESS,TransactionStatus(status=f"Received payment from {sender}. Thank You"))

if __name__=="__main__":
    restaurant.run()

