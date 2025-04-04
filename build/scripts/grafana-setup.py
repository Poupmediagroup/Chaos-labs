#!/usr/bin/env python3
# Written by: Tai H.
# This script will automatically set up a grafana dashboard for nede exporter metrics. 
# It downloads the Json for grafana dashboard (1860) and imports it inot grafana

import requests
import base64
import json

# Setting credentials
username = 'admin'
password = 'admin'
grafana_creds = f'{username}:{password}'

# Base64 encoding credentials
encoded_grafana_creds = base64.b64encode(
    grafana_creds.encode('utf-8')).decode('utf-8')

# Get the public IP address using ipinfo.io
ipinfo_response = requests.get('https://ipinfo.io/ip')

# response.text gives the plain IP without JSON structure
host_ip = ipinfo_response.text.strip()

# Create Grafana Service Account
url = f'http://{host_ip}:3000/api/serviceaccounts'
service_acct_headers = {
    'Content-Type': 'application/json',
    'Authorization': f'Basic {encoded_grafana_creds}',
}
service_acct_data = {
    'name': 'test-service-account',
    'role': 'Admin',
    'isDisabled': False
}

service_acct_response = requests.post(
    url, headers=service_acct_headers, json=service_acct_data)

# Error handling for service account creation
if service_acct_response.status_code == 201:
    data = service_acct_response.json()
    id = data.get('id')
    name = data.get('name')
    print(f'"{name}" was successfully created')
else:
    print('Failed to create the service account')
    print(f'Status Code: {service_acct_response.text}')

# Create Service account token
service_acct_url = f'http://{host_ip}:3000/api/serviceaccounts/{id}/tokens'
service_acct_headers = {
    'Content-Type': 'application/json',
    'Authorization': f'Basic {encoded_grafana_creds}',
}
service_acct_token = {
    'name': 'test-service-account',
    'secondsToLive': 0
}

service_acct_token_response = requests.post(
    service_acct_url, headers=service_acct_headers, json=service_acct_token)

# Error handling for service account toke creation 
if service_acct_token_response.status_code == 200:
    token_data = service_acct_token_response.json()
    key = token_data.get('key')
    print(f'Token is: {key}')
else:
    print('Failed to create the service account token')
    print(f'{service_acct_token_response.text}')


# Add Node Exporter Data Source
add_data_source_url = f'http://{host_ip}:3000/api/datasources'

add_data_source_headers = {
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {key}',
}

add_data_source_body = {
    'name': 'Prometheus',
    'type': 'prometheus',
    'url': f'http://{host_ip}:9090',
    'access': 'proxy',
    'basicAuth': False
}

add_data_source_response = requests.post(
    add_data_source_url, headers=add_data_source_headers, json=add_data_source_body)

if add_data_source_response.status_code == 200:
    data_source_json = add_data_source_response.json()
    data_source_name = data_source_json.get('name')
    print(f'Successfully added: {name} as a Datasource')
else:
    print('Failed to add Node exporter as a data source')
    print(f'{add_data_source_response.text}')


# Downloading the json for Grafana Dashboard (1860) this is a node exporter dashboard
grafana_dashboard_url = "https://grafana.com/api/dashboards/1860/revisions/latest/download"
grafana_dashboard_response = requests.get(grafana_dashboard_url)

if grafana_dashboard_response.status_code == 200:
    with open('dashboard_1860.json', 'w') as file:
        file.write(grafana_dashboard_response.text)
    print('successfully downloaded Grafana dashboard:1860')
else:
    print(
        f'Failed to download Grafana dashboard: 1860 with status code: {grafana_dashboard.status_code}')
    print(grafana_dashboard_response.text)
    exit(1)

# Import the downloaded dashboard (1860)
with open('dashboard_1860.json', 'r') as file:
    dashboard_1860 = json.load(file)

# Setting these properties to none for a clean import 
dashboard_1860["id"] = None
dashboard_1860["uid"] = None
dashboard_1860["tags"] = None
dashboard_1860["title"] = 'Prometheus Dash'

dashboard_url = f'http://{host_ip}:3000/api/dashboards/db'
dashboard_headers = {
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {key}',
}

dashboard_body = {
    'dashboard': dashboard_1860,
    'folderUid': None,
    'messsage': 'Imported via api',
    'overwrite': False
}

dashboard_response = requests.post(
    dashboard_url, headers=dashboard_headers, json=dashboard_body)

# Error handling for dashboard (1860) import
if dashboard_response.status_code == 200:
    dashboard_data = dashboard_response.json()
    dashboard_title = dashboard_data.get('slug')
    print(f'Successfully created dashboard: {dashboard_title}')
else:
    print('Failed to import the dashboard')
    print(f'Error: {dashboard_response.text}')
