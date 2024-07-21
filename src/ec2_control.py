import boto3

ec2 = boto3.client('ec2')


def lambda_handler(event, context):
    """
    Main function to handle the Lambda event.
    
    Parameters:
    event (dict): The event data passed to the Lambda function.
    context (LambdaContext): The runtime information of the Lambda function.
    
    Returns:
    dict: A dictionary with the status and details of the operation.
    """
    action = event.get('action', 'stop')  # 'start' or 'stop'
    tag_name = event.get('tag_name', 'Name')
    tag_value = event.get('tag_value', 'Rowden')  # String to match in the tag value

    instances = get_instances_by_tag(tag_name, tag_value)

    if action == 'start':
        start_instances(instances)
    elif action == 'stop':
        stop_instances(instances)
    else:
        return {'status': 'error', 'message': 'Invalid action'}

    return {'status': 'success', 'action': action, 'instances': instances}


def get_instances_by_tag(tag_name, tag_value):
    """
    Retrieve a list of EC2 instances that match a given tag name and tag value.
    
    Parameters:
    tag_name (str): The name of the tag to filter by.
    tag_value (str): The value of the tag to filter by (supports wildcards).
    
    Returns:
    list: A list of instance IDs that match the filter.
    """
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': f'tag:{tag_name}',
                'Values': [f'*{tag_value}*']  # Use wildcards to match any part of the tag value
            }
        ]
    )
    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instances.append(instance['InstanceId'])
    return instances


def start_instances(instances):
    """
    Start the given list of EC2 instances.
    
    Parameters:
    instances (list): The list of instance IDs to start.
    """
    ec2.start_instances(InstanceIds=instances)
    ec2.get_waiter('instance_running').wait(InstanceIds=instances)


def stop_instances(instances):
    """
    Stop the given list of EC2 instances.
    
    Parameters:
    instances (list): The list of instance IDs to stop.
    """
    ec2.stop_instances(InstanceIds=instances)
    ec2.get_waiter('instance_stopped').wait(InstanceIds=instances)
