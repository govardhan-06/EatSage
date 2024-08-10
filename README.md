# Eatsage

## Overview

Eatsage is an innovative food delivery application that integrates AI and Blockchain technology to enhance the user experience. This app utilizes AI agents dedicated to specific tasks, creating a seamless and efficient system for food ordering and delivery.

## How Does the App Work?

The Eatsage app features three AI agents:

1. _Customer Agent_
2. _Valet Agent_
3. _Restaurant Agent_

### Customer Agent

The Customer Agent's backend is responsible for sending trigger notifications to the Restaurant Agent when an order is placed. The frontend is a basic chat interface powered by Lama-3.

### Restaurant Agent

The Restaurant Agent's backend sends trigger notifications to the Valet Agent when an order is accepted by the restaurant. The frontend displays a list of all available order requests.

### Valet Agent

The Valet Agent's frontend is a list view of all delivery options, allowing the valet to accept or decline orders.

### Additional Features

- The Customer Agent can find nearby restaurants using the device's location.
- Payments are processed through the Fetch Blockchain using the Almanac smart contract. Users must purchase 'FET' tokens, and payments are made automatically.

## Pitch Deck

We've put together a comprehensive [Pitch Deck](https://docs.google.com/presentation/d/1QY-O7IDLwvKwFlUQzm85tkdSfjIWLUD9/edit?usp=sharing&ouid=100396215887832693875&rtpof=true&sd=true) that outlines our project **EatSage** in detail. This deck covers the problem we're solving, our innovative approach using decentralized AI agents, the technology stack, and our roadmap for future development.

Check it out to get a deeper understanding of our vision and the impact we aim to achieve with **EatSage**.

### Note

Currently, the [backend fastapi server](https://eatsage-backend.onrender.com/) is hosted on render using a free tier account. This may lead to temporary outage of the service and may cause `INTERNAL SERVER ERROR`

## Environment Variables

The .env file contains the following environment variables.
_Note:_ The values below are dummy values and should be replaced with actual credentials.

```sh
GROQ_API_KEY="gsk_dummy_api_key"

# Customer Agent
CUST_NAME="EatSage_Customer"
CUST_SEED_PHRASE="customer is the king. Welcome to EatSage!!"
CUST_ADDRESS="agent1q0k2rwfj5up9s7z8896pyrchzqawdywcj4ua4vwhfdky0fstvvjtqu3f9kw"
CUST_STORAGE="agent1q0k2rwfj5u_data.json"

# Delivery Partner Agent
DEL_NAME="EatSage_Delivery"
DEL_SEED_PHRASE="EatSage delivery partner, committed to customer service"
DEL_ADDRESS="agent1qgu230r5w774zhc88ncs8ume2v9hzuf7crfeqn5r4pxmk98jp46wsg2mpdx"
DEL_STORAGE="agent1qgu230r5w7_data.json"

# Restaurant Agent
RES_NAME="EatSage_Restaurant"
RES_SEED_PHRASE="We are the elite eatsage restaurants!! Food Quality and Customer service is our topmost priority"
RES_ADDRESS="agent1q2h5xkny4c9kmde7c7hy3394y708us338j55a5y0yfk3t3udwqrxk4zp73s"
RES_STORAGE="agent1q2h5xkny4c_data.json"
```

## Guidelines on how to acquire the api keys:

To get the `GROQ_API_KEY` and set it up, follow these steps:

1. **Create or Log into your GROQ Account:**

   - Go to the GROQ platform's official documenation website: [Docs-Groq](https://console.groq.com/docs/quickstart).
   - Sign up for an account if you don't have one, or log in if you already have an account.

2. **Access API Keys:**

   - Once logged in, navigate to the API section, usually found under the "Settings" or "Developer" section in your account dashboard.
   - Look for the option to generate a new API key.

3. **Generate the API Key:**

   - Click on the "Generate API Key" button.
   - Provide a name or description for the key if prompted.
   - The platform will generate a unique API key, which is your `GROQ_API_KEY`.

4. **Copy the API Key:**

   - Copy the generated API key. It might look something like this: `gsk_abcdef1234567890`.

5. **Set the API Key as an Environment Variable:**

   - In your terminal or command prompt, you can set the API key as an environment variable by running:
     ```bash
     export GROQ_API_KEY="gsk_abcdef1234567890"
     ```
   - Replace `"gsk_abcdef1234567890"` with your actual API key.

Make sure to keep your API key secure and do not share it publicly.

## Installation

### To setup the backend server:

1. Clone the repository:

```bash
git clone https://github.com/govardhan-06/eatsage.git
```

2. Navigate to the project directory:

```bash
cd eatsage
```

3. Create and activate a virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # On Windows use `venv\Scripts\activate`
```

4. Install the required packages:

```bash
pip install -r requirements.txt
```

5. Set up your .env file with the appropriate values.

### To setup the flutter app:

<flutter app setup>

## Usage

1. Start the backend:

```sh
python backend/src/__init__.py
```

2. Start the frontend:

```sh
<flutter command to run the app>
```

3. Start interacting with the Eatsage app.

## License

This project is licensed under the Apache License. See the LICENSE file for details.

## Acknowledgements

Special thanks to the contributors and the open-source community for their support.
