# Eatsage

## Overview

Eatsage is an innovative food delivery application that integrates AI and Blockchain technology to enhance the user experience. This app utilizes AI agents dedicated to specific tasks, creating a seamless and efficient system for food ordering and delivery.

## How Does the App Work?

The Eatsage app features three AI agents:

1. *Customer Agent*
2. *Valet Agent*
3. *Restaurant Agent*

### Customer Agent
The Customer Agent's backend is responsible for sending trigger notifications to the Restaurant Agent when an order is placed. The frontend is a basic chat interface powered by Lama-3.

### Restaurant Agent
The Restaurant Agent's backend sends trigger notifications to the Valet Agent when an order is accepted by the restaurant. The frontend displays a list of all available order requests.

### Valet Agent
The Valet Agent's frontend is a list view of all delivery options, allowing the valet to accept or decline orders.

### Additional Features
- The Customer Agent can find nearby restaurants using the device's location.
- Payments are processed through the Fetch Blockchain using the Almanac smart contract. Users must purchase 'FET' tokens, and payments are made automatically.

## Directory Structure

plaintext
backend/
    ├── __pycache__
    └── src/
        ├── __pycache__
        ├── agents/
        ├── pipeline/
        ├── protocols/
        ├── restaurantData/
        ├── services/
        ├── triggers/
        ├── utils/
        │   ├── __init__.py
        │   └── contextLoader.py
        └── __init__.py
eatsage/
logs/
.env
.gitignore
LICENSE
ModelTesting.ipynb
README.md
requirements.txt

## Environment Variables

The .env file contains the following environment variables. *Note:* The values below are dummy values and should be replaced with actual credentials.

plaintext
MONGO_DB_URI="mongodb+srv://username:password@restaurant.mongodb.net/?retryWrites=true&w=majority&appName=Restaurant"
GROQ_API_KEY="gsk_dummy_api_key"
GEMINI_API_KEY="AIzaSy_dummy_api_key"

USER_EMAIL_ADDRESS="user@example.com"
EATSAGE_MASTERKEY="eyJhbGciOiJSUzI1NiJ9.eyJleHAiOjE3Mjk2NDgzNjAsImlhdCI6MTcyMTg3MjM2MCwiaXNzIjoiZmV0Y2guYWkiLCJqdGkiOiI5Y2ZiMTY3MzdkZTExNDg4Y2IwN2U5MmQiLCJzY29wZSI6ImF2Iiwic3ViIjoiZjU0YWQyNDdiNzg0NzM3MDE1YmZjNzJjMjU3YzhiMzFmM2VlNGYxNDJmMjgxNzgyIn0.dummy_master_key"

# Customer Agent
CUST_NAME="EatSage_Customer"
CUST_SEED_PHRASE="customer is the king. Welcome to EatSage!!"
CUST_ADDRESS="agent1q0dummyaddress"
CUST_MAILBOX="7750ebca-3cb0-4c9e-93be-dummy_mailbox"

# Delivery Partner Agent
DEL_NAME="EatSage_Delivery"
DEL_SEED_PHRASE="EatSage delivery partner, committed to customer service"
DEL_ADDRESS="agent1qdummyaddress"

# Restaurant Agent
RES_NAME="EatSage_Restaurant"
RES_SEED_PHRASE="We are the elite eatsage restaurants!! Food Quality and Customer service is our topmost priority"
RES_ADDRESS="agent1qdummyaddress"


## Installation

1. Clone the repository:

bash
git clone https://github.com/govardhan-06/eatsage.git


2. Navigate to the project directory:

bash
cd eatsage


3. Create and activate a virtual environment:

bash
python -m venv venv
source venv/bin/activate  # On Windows use `venv\Scripts\activate`


4. Install the required packages:

bash
pip install -r requirements.txt


5. Set up your .env file with the appropriate values.

## Usage

1. Start the backend:

bash
python backend/src/__init__.py


2. Access the frontend and start interacting with the Eatsage app.

## License

This project is licensed under the Apache License. See the LICENSE file for details.

## Acknowledgements

Special thanks to the contributors and the open-source community for their support.
