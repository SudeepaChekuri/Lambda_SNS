#def lambda_handler(event, context):
 #   students = ['Alice', 'Bob', 'Charlie', 'David', 'Eve']
    
  #  response = {
   #     'statusCode': 200,
    #    'body': 'students list in the class'
    #}
    
    #return response
import json

def lambda_handler(event, context):
    # Replace the event data with your desired structure
    my_event = {
        "Records": [
            {
                "EventSource": "aws:sns",
                "EventVersion": "1.0",
                "EventSubscriptionArn": "arn:aws:sns:us-east-1:123456789012:ExampleTopic",
                "Sns": {
                    "Type": "Notification",
                    "MessageId": "abc123",
                    "TopicArn": "arn:aws:sns:us-east-1:123456789012:ExampleTopic",
                    "Subject": "ExampleSubject",
                    "Message": "Hello from SNS!",
                    "MessageAttributes": {
                        "Attribute1": {
                            "Type": "String",
                            "Value": "Value1"
                        },
                        "Attribute2": {
                            "Type": "String",
                            "Value": "Value2"
                        }
                    }
                }
            }
        ]
    }

    # Retrieve the message from the modified event structure
    sns_message = my_event['Records'][0]['Sns']['Message']
    
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


  
