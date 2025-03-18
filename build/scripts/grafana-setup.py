#!/usr/bin/env python3

import requests
import socket
import base64

username = 'admin'
password = 'admin'

# Setting credentials
grafana_creds = f'{username}:{password}'

# Base64 encoding credentials
encoded_grafana_creds = base64.b64encode(grafana_creds.encode('utf-8')).decode('utf-8')

# Get the public IP address using ipinfo.io
ipinfo_response = requests.get('https://ipinfo.io/ip')


host_ip = ipinfo_response.text.strip()  # response.text gives the plain IP without JSON structure

# Post request for creating Grafana service account
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

service_acct_response = requests.post(url,headers=service_acct_headers,json=service_acct_data)

print(f'Status Code: {service_acct_response.status_code}')
print(f'Response JSON: {service_acct_response.json()}')