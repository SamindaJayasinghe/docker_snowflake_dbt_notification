# Use an official Python runtime as a parent image
FROM python:3.10-slim

WORKDIR /snow1/
# copy .. means you copy all in this folder to docker folder
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN dbt deps