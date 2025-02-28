# Real Estate Keycloak Render

This repository is for the Keycloak Render project for real estate applications.

## Production

The production environment is running at [https://real-estate-keycloak-render.onrender.com/](https://real-estate-keycloak-render.onrender.com/).

# To Run In Local

This guide provides step-by-step instructions to set up the development environment locally, including configuring Keycloak as the authentication and authorization server.

## Prerequisites

- Docker: Ensure Docker is installed and running on your machine. Download from [docker.com](https://www.docker.com) if needed.
- Access to a terminal (bash, cmd, PowerShell, etc.).
- Internet connection to pull the Keycloak image.

## Step 1: Run Keycloak with Docker

Keycloak will serve as the authentication and authorization server for the microservices. Follow these steps to start it:

1. Open a terminal on your machine.
2. Run the following command to start Keycloak in development mode:

    ```bash
    docker run -p 8080:8080 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:26.1.3 start-dev
    ```

### Explanation:

- `-p 8080:8080`: Maps port 8080 from the container to your local machine.
- `-e KC_BOOTSTRAP_ADMIN_USERNAME=admin`: Sets the admin username to "admin".
- `-e KC_BOOTSTRAP_ADMIN_PASSWORD=admin`: Sets the admin password to "admin".
- `quay.io/keycloak/keycloak:26.1.3`: Uses Keycloak version 26.1.3.
- `start-dev`: Starts Keycloak in development mode.

Wait for the container to start. You’ll see logs indicating Keycloak is ready when something like this appears:

```
[INFO] Listening on: http://0.0.0.0:8080
```

## Step 2: Access the Keycloak Dashboard

1. Open your browser and go to: [http://localhost:8080](http://localhost:8080).
2. Click on "Administration Console".
3. Enter the credentials:
    - Username: admin
    - Password: admin
4. Click "Sign In" to access the admin panel.

## Step 3: Create the Realm

A realm in Keycloak is an isolated space to manage users, clients, and roles. Let’s create one for the app:

1. In the admin panel, click the dropdown in the top-left corner (where it says "master").
2. Click "Create Realm".
3. In the "Name" field, enter: `nullius-real-estate-realm`.
4. Click "Create".

## Step 4: Configure the Realm

### Enable Authentication and Authorization Flow

1. From the sidebar, select "Authentication".
2. Ensure the "Standard Flow" is enabled:
    - Locate the "browser" flow in the list.
    - Verify it’s marked as "Enabled" and includes steps like "Cookie", "Identity Provider Redirector", and "Forms".
    - If not enabled, click the three dots (...) next to "browser" and select "Enable".

### Configure Realm Settings

1. From the sidebar, select "Realm Settings".
2. Go to the "Login" tab:
    - Enable "Email as username" (toggle it on).
3. Go to the "User Profile" tab:
    - Click "Edit" or the pencil icon next to the attributes.
    - Remove the "firstName" and "lastName" attributes:
        - Find each attribute in the list and click the trash icon to delete them.
    - Keep only "email" and "password" as required attributes.
    - Save changes with "Save".

## Step 5: Create and Configure the Client

The client will represent your auth-service in Keycloak:

1. From the sidebar, select "Clients".
2. Click "Create Client".
3. Configure the fields:
    - Client ID: `auth-service-client`.
    - Client Type: Leave as "OpenID Connect" (default).
4. Click "Next".
5. In the next screen:
    - Enable "Client Authentication" (toggle it on).
    - Enable "Standard Flow" (ensure it’s checked under "Authentication Flow").
    - Disable other flows if unnecessary (e.g., "Direct Access Grants" or "Implicit Flow"), keeping only "Standard Flow" active.
6. Click "Save".

## Step 6: Configure Client Roles

We need to assign permissions to the client to manage users:

1. In the clients list, click on `auth-service-client`.
2. Go to the "Service Account Roles" tab.
3. In the "Client Roles" field, select "realm-management" from the dropdown.
4. In the available roles list, find "manage-users".
5. Select "manage-users" and click "Assign" to assign it to the client.
6. Verify it appears in the assigned roles list.

## Step 7: Verify the Configuration

1. From the sidebar, select "Realm Settings" and copy the "OpenID Endpoint Configuration" URL (e.g., `http://localhost:8080/realms/nullius-real-estate-realm/.well-known/openid-configuration`).
2. Open this URL in your browser to confirm Keycloak is configured correctly and returns a JSON with the authentication endpoints.
