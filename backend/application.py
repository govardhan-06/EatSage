from fastapi import FastAPI
from fastapi.responses import RedirectResponse
import sys,uvicorn,os
import subprocess
from dotenv import load_dotenv
from uagents.query import query

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))
from backend.src.utils.exception import customException
from pydantic import BaseModel

CUST_ADDRESS=os.getenv("CUST_ADDRESS")
RES_ADDRESS=os.getenv("RES_ADDRESS")
DEL_ADDRESS=os.getenv("DEL_ADDRESS")

load_dotenv()

app = FastAPI()

class UserPrompt(BaseModel):
    prompt:str

async def agent_query(req):
    response = await query(destination=CUST_ADDRESS, message=req, timeout=15.0)
    return response
 
@app.get("/")
def home():
    '''
    This function is used to redirect to the swaggerUI page.
    '''
    return RedirectResponse(url="/docs")
 
@app.post("/customer")
async def run_customer():
    '''
    This function is used to run the customer agent.
    '''
    try:
        subprocess.Popen(["python", "backend/src/agents/customer.py"])
    except Exception as e:
        raise customException(e,sys)

@app.post("/restaurant")
async def run_restaurant():
    '''
    This function is used to run the restaurant agent.
    '''
    try:
        subprocess.Popen(["python", "backend/src/agents/restaurants.py"])
    except Exception as e:
        raise customException(e,sys)
    
@app.post("/valet")
async def run_valet():
    '''
    This function is used to run the valet agent.
    '''
    try:
        subprocess.Popen(["python", "backend/src/agents/valet.py"])
    except Exception as e:
        raise customException(e,sys)

@app.post("/prompt")
async def cust_prompt(req:UserPrompt):
    '''
    This function is used to run the valet agent.
    '''
    try:
        res = await agent_query(req)
        return f"successful call - agent response: {res}"
    except Exception as e:
        raise customException(e,sys)

if __name__=="__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)


