#!/usr/bin/env python3

import requests
import base64
import json

username = 'admin'
password = 'chaos'

# Setting credentials
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

data = service_acct_response.json()

id = data.get('id')
name = data.get('name')

print(f'Status Code: {service_acct_response.status_code}')

print(f'Service account ID: {id}')
print(f'Service account Name: {name}')


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

token_data = service_acct_token_response.json()
key = token_data.get('key')
print(f'Status Code: {service_acct_token_response.status_code}')
print(f'Token is: {key}')


# Add Node Exporter Data Source

data_source_url = f'http://{host_ip}:3000/api/datasources'
data_source_headers = {
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {key}',
}
data_source_body = {
    'name': 'Prometheus',
    'type': 'prometheus',
    'url': f'http://{host_ip}:9090',
    'access': 'proxy',
    'basicAuth': False
}

data_source_response = requests.post(
    data_source_url, headers=data_source_headers, json=data_source_body)

type_data = data_source_response.json()

name = type_data.get('name')

print(f'Response is: {type_data}')
print(f'Status Code for datasource import: {data_source_response.status_code}')
print(f'Data Source: {name} has been added')

# Import Node Exporter Dashboard

# Downloading the json definition
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

# Import Dashboard
with open('dashboard_1860.json', 'r') as file:
    dashboard_1860 = json.load(file)

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

dashboard_data = dashboard_response.json()
dashboard_title = dashboard_data.get('slug')

print(f'Status code for dashboard setup: {dashboard_response.status_code}')
print(f'Dashboard response: {dashboard_data}')
print(f'Successfully created dashboard: {dashboard_title}')
