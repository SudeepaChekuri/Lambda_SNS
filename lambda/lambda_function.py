def lambda_handler(event, context):
    students = ['Alice', 'Bob', 'Charlie', 'David', 'Eve']
    
    response = {
        'statusCode': 200,
        'body': 'students list in the class'
    }
    
    return response

  
