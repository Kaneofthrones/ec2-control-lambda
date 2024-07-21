import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    action = event.get('action', 'stop')  # 'start' or 'stop'
    tag_name = event.get('tag_name', 'Name')
    tag_value = event.get('tag_value', 'MyInstance')

    instances = get_instances_by_tag(tag_name, tag_value)

    if action == 'start':
        start_instances(instances)
    elif action == 'stop':
        stop_instances(instances)
    else:
        return {'status': 'error', 'message': 'Invalid action'}

    return {'status': 'success', 'action': action, 'instances': instances}

def get_instances_by_tag(tag_name, tag_value):
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': f'tag:{tag_name}',
                'Values': [tag_value]
            }
        ]
    )
    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instances.append(instance['InstanceId'])
    return instances

def start_instances(instances):
    ec2.start_instances(InstanceIds=instances)
    ec2.get_waiter('instance_running').wait(InstanceIds=instances)

def stop_instances(instances):
    ec2.stop_instances(InstanceIds=instances)
    ec2.get_waiter('instance_stopped').wait(InstanceIds=instances)

