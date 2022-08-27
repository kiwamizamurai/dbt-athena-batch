FROM python:3.10-slim

# Update and install system packages
RUN apt-get update -y && \
  apt-get install --no-install-recommends -y -q \
  git libpq-dev python-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install -U pip


# Set environment variables
ENV DBT_DIR /dbt

# Set working directory
WORKDIR $DBT_DIR

# Install DBT
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . /dbt
