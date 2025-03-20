import requests
import base64

username = 'admin'
password = 'chaos'

# Setting credentials
grafana_creds = f'{username}:{password}'

# Base64 encoding credentials
encoded_grafana_creds = base64.b64encode(grafana_creds.encode('utf-8')).decode('utf-8')

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

service_acct_response = requests.post(url,headers=service_acct_headers,json=service_acct_data)

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

service_acct_token_response = requests.post(service_acct_url,headers=service_acct_headers,json=service_acct_token)

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

data_source_response = requests.post(data_source_url,headers=data_source_headers,json=data_source_body)

type_data = data_source_response.json()

name = type_data.get('name')

print(f'Response is: {type_data}')
print(f'Status Code for datasource import: {data_source_response.status_code}')
print(f'Data Source: {name} has been added')