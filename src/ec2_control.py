import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name='eu-west-2')
    try:
        action = event.get('action', 'stop')  # 'start' or 'stop'
        tag_name = event.get('tag_name', 'Name')
        tag_value = event.get('tag_value', 'Rowden')  # String to match in the tag value

        instances = get_instances_by_tag(ec2, tag_name, tag_value)

        if action == 'start':
            start_instances(ec2, instances)
        elif action == 'stop':
            stop_instances(ec2, instances)
        else:
            return {'status': 'error', 'message': 'Invalid action'}

        return {'status': 'success', 'action': action, 'instances': instances}
    except Exception as e:
        logger.error("Error occurred: %s", e)
        raise e

def get_instances_by_tag(ec2, tag_name, tag_value):
    try:
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
    except Exception as e:
        logger.error("Error in get_instances_by_tag: %s", e)
        raise e

def start_instances(ec2, instances):
    try:
        ec2.start_instances(InstanceIds=instances)
        ec2.get_waiter('instance_running').wait(InstanceIds=instances)
    except Exception as e:
        logger.error("Error in start_instances: %s", e)
        raise e

def stop_instances(ec2, instances):
    try:
        ec2.stop_instances(InstanceIds=instances)
        ec2.get_waiter('instance_stopped').wait(InstanceIds=instances)
    except Exception as e:
        logger.error("Error in stop_instances: %s", e)
        raise e
