#!/bin/bash

cd ../src
pip install -r requirements.txt -t .
zip -r9 ../ec2_control_lambda.zip .
cd ..

