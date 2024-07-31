from fastapi import FastAPI
from fastapi.responses import RedirectResponse
import sys,uvicorn,os,json
from starlette.responses import JSONResponse
import subprocess
from dotenv import load_dotenv
from uagents.query import query
from uagents import Model

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))
from backend.src.utils.exception import customException
from backend.src.utils.logger import logging

load_dotenv()

CUST_ADDRESS=os.getenv("CUST_ADDRESS")
RES_ADDRESS=os.getenv("RES_ADDRESS")
DEL_ADDRESS=os.getenv("DEL_ADDRESS")

CUST_STORAGE=os.getenv("CUST_STORAGE")
RES_STORAGE=os.getenv("RES_STORAGE")
DEL_STORAGE=os.getenv("DEL_STORAGE")

class UserPrompt(Model):
    prompt: str

app = FastAPI()

async def agent_query(req):
    response = await query(destination=CUST_ADDRESS, message=UserPrompt(prompt=req), timeout=15.0)
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
async def cust_prompt(prompt:str):
    '''
    This function is used to send a prompt to the customer agent.
    Returns the model response as a JSON
    '''
    try:
        await agent_query(prompt)
        # Open and read the JSON file
        with open(CUST_STORAGE, 'r') as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError as e:
                raise customException(f"Error reading JSON file: {str(e)}", sys)

        return JSONResponse(content={"message": "Success", "data": data['Response']}, status_code=200)

    except customException as e:
        logging.error(e)
        return JSONResponse(content={"error": {e}}, status_code=500)

@app.post("/confirmOrder")
async def cust_confirmation():
    '''
    This function is used to confirm an order with the customer agent.
    Make the change in the agent storage
    '''
    try:
        # Open and read the JSON file
        with open(CUST_STORAGE, 'r') as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError as e:
                raise customException(f"Error reading JSON file: {str(e)}", sys)

        data['confirm_order'] = 'yes'

        # Open the file in write mode to save the changes
        with open(CUST_STORAGE, 'w') as f:
            try:
                json.dump(data, f, indent=4)
            except json.JSONDecodeError as e:
                raise customException(f"Error writing JSON file: {str(e)}", sys)

    except customException as e:
        logging.error(e)
        return JSONResponse(content={"error": {e}}, status_code=500)
    
if __name__=="__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)


