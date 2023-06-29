import json

def lambda_handler(event, context):
    # Process the event
    message = event['Records'][0]['Sns']['Message']
    print(f"Received message: {message}")
    
    # Perform some business logic
    response = {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
    
    return response
    
  
