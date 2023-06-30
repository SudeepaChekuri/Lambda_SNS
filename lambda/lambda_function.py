#def lambda_handler(event, context):
 #   students = ['Alice', 'Bob', 'Charlie', 'David', 'Eve']
    
  #  response = {
   #     'statusCode': 200,
    #    'body': 'students list in the class'
    #}
    
    #return response
import json

def lambda_handler(event, context):
    # Retrieve the message from the SNS event
    sns_message = event['Records'][0]['Sns']['Message']
    
    # Process the message
    processed_message = process_message(sns_message)
    
    # Return a response
    response = {
        'statusCode': 200,
        'body': json.dumps({'processed_message': processed_message})
    }
    return response

def process_message(message):
    # Your message processing logic here
    return message.upper()


  
