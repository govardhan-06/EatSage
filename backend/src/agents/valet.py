from uagents import Agent,Context,Model
from uagents.network import wait_for_tx_to_complete
from uagents.setup import fund_agent_if_low

import os,sys
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))
from backend.src.protocols.valet_proto import get_Calls,initiate_payment,confirm_pay

load_dotenv()

NAME=os.getenv("DEL_NAME")
SEED_PHRASE=os.getenv("DEL_SEED_PHRASE")
DEL_ADDRESS=os.getenv("DEL_ADDRESS")
CUST_ADDRESS=os.getenv("CUST_ADDRESS")

valet=Agent(
    name=NAME,
    port=8002,
    seed=SEED_PHRASE,
    endpoint=["http://127.0.0.1:8002/submit"]
)

fund_agent_if_low(valet.wallet.address())

valet.include(get_Calls,publish_manifest=True)

class PaymentRequest(Model):
    wallet_address: str
    amount: int
    denom: str
 
class TransactionInfo(Model):
    tx_hash: str
    amount:str
    denom:str

class Acknowledgment(Model):
    message:str
    final_bill:float

@valet.on_message(model=Acknowledgment)
async def request_bill_payment(ctx: Context,sender:str,Acknowledgment:str):
    AMOUNT=Acknowledgment.final_bill
    DENOM="atestfet"
    await ctx.send(CUST_ADDRESS,PaymentRequest(wallet_address=str(valet.wallet.address()), amount=AMOUNT, denom=DENOM))

@valet.on_message(model=TransactionInfo)
async def confirm_transaction(ctx: Context, sender: str, msg: TransactionInfo):
    ctx.logger.info(f"Received transaction info from {sender}: {msg}")
 
    tx_resp = await wait_for_tx_to_complete(msg.tx_hash, ctx.ledger)
    coin_received = tx_resp.events["coin_received"]
 
    if (
        coin_received["receiver"] == str(valet.wallet.address())
        and coin_received["amount"] == f"{msg.amount}{msg.denom}"
    ):
        ctx.logger.info(f"Transaction was successful: {coin_received}")

if __name__=="__main__":
    valet.run()

