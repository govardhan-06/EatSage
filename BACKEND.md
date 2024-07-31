## API Documentation for Backend

This document provides a comprehensive guide to the backend API endpoints for managing customer, restaurant, and valet agents. The API is built using FastAPI and provides endpoints to run agents, send prompts, confirm orders, and retrieve information.

### Base URL

All endpoints are accessible at the base URL: `http://0.0.0.0:8000`

### Endpoints

#### 1. Home

- **Endpoint**: `/`
- **Method**: `GET`
- **Description**: Redirects to the SwaggerUI documentation page.

#### 2. Run Customer Agent

- **Endpoint**: `/customer`
- **Method**: `POST`
- **Description**: Starts the customer agent.
- **Responses**:
  - `200 OK`: Customer agent started successfully.
  - `500 Internal Server Error`: Error occurred while starting the customer agent.

#### 3. Run Restaurant Agent

- **Endpoint**: `/restaurant`
- **Method**: `POST`
- **Description**: Starts the restaurant agent.
- **Responses**:
  - `200 OK`: Restaurant agent started successfully.
  - `500 Internal Server Error`: Error occurred while starting the restaurant agent.

#### 4. Run Valet Agent

- **Endpoint**: `/valet`
- **Method**: `POST`
- **Description**: Starts the valet agent.
- **Responses**:
  - `200 OK`: Valet agent started successfully.
  - `500 Internal Server Error`: Error occurred while starting the valet agent.

#### 5. Send Customer Prompt

- **Endpoint**: `/prompt`
- **Method**: `POST`
- **Description**: Sends a prompt to the customer agent.
- **Parameters**:
  - `prompt`: (string) The prompt message to be sent.
- **Responses**:
  - `200 OK`: Prompt sent successfully, returns restaurant and dishes information.
  - `500 Internal Server Error`: Error occurred while processing the prompt.

#### 6. Confirm Customer Order

- **Endpoint**: `/confirmOrder`
- **Method**: `POST`
- **Description**: Confirms an order with the customer agent.
- **Parameters**:
  - `req`: (boolean) Confirmation status.
- **Responses**:
  - `200 OK`: Order confirmed successfully.
  - `500 Internal Server Error`: Error occurred while confirming the order.

#### 7. Restaurant Confirmation

- **Endpoint**: `/resConfirm`
- **Method**: `POST`
- **Description**: Retrieves confirmation message from the restaurant agent.
- **Responses**:
  - `200 OK`: Success, returns order details and status.
  - `500 Internal Server Error`: Error occurred while retrieving the confirmation message.

#### 8. Valet Message

- **Endpoint**: `/valetMessage`
- **Method**: `POST`
- **Description**: Retrieves valet agent information.
- **Responses**:
  - `200 OK`: Success, returns valet address and message.
  - `500 Internal Server Error`: Error occurred while retrieving valet information.

#### 9. Get Current Orders

- **Endpoint**: `/currentOrders`
- **Method**: `POST`
- **Description**: Retrieves current orders from the customer agent for the restaurant.
- **Responses**:
  - `200 OK`: Success, returns current orders.
  - `500 Internal Server Error`: Error occurred while retrieving current orders.

#### 10. Accept Order

- **Endpoint**: `/acceptOrder`
- **Method**: `POST`
- **Description**: Accepts an order from the customer agent for the restaurant.
- **Parameters**:
  - `req`: (boolean) Acceptance status.
- **Responses**:
  - `200 OK`: Order accepted successfully.
  - `500 Internal Server Error`: Error occurred while accepting the order.

#### 11. Call Valet

- **Endpoint**: `/callValet`
- **Method**: `POST`
- **Description**: Calls the valet agent.
- **Responses**:
  - `200 OK`: Valet call initiated successfully.
  - `500 Internal Server Error`: Error occurred while calling the valet.

#### 12. Get Valet Information

- **Endpoint**: `/getValet`
- **Method**: `POST`
- **Description**: Retrieves valet agent's information.
- **Responses**:
  - `200 OK`: Success, returns valet address, message, and location.
  - `500 Internal Server Error`: Error occurred while retrieving valet information.

#### 13. Get Current Call

- **Endpoint**: `/currentCall`
- **Method**: `POST`
- **Description**: Retrieves the current delivery call from the restaurant agent for the valet.
- **Responses**:
  - `200 OK`: Success, returns current call details.
  - `500 Internal Server Error`: Error occurred while retrieving the current call.

#### 14. Confirm Delivery Call

- **Endpoint**: `/confirmCall`
- **Method**: `POST`
- **Description**: Confirms a delivery call from the restaurant agent for the valet.
- **Parameters**:
  - `req`: (boolean) Confirmation status.
- **Responses**:
  - `200 OK`: Delivery call accepted successfully.
  - `500 Internal Server Error`: Error occurred while confirming the delivery call.

### Error Handling

- **500 Internal Server Error**: Indicates that an error occurred while processing the request. The response will contain the error details.

### Running the Server

To run the FastAPI server, use the following command:

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

### Additional Information

- **SwaggerUI**: The API documentation can be accessed at `/docs` for interactive API testing.
- **JSON Responses**: All successful responses will have a `message` field indicating the success status and additional data as specified. Errors will have an `error` field with the error details.
