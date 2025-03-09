# Use a Node.js Alpine image as the base
FROM node:18-alpine

# Install Python and pip
RUN apk add --no-cache python3 py3-pip

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Upgrade pip and install the required library inside the virtual environment
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install youtube-transcript-api

# Copy the n8n application files from the official n8n image
COPY --from=docker.n8n.io/n8nio/n8n /usr/local /usr/local
COPY --from=docker.n8n.io/n8nio/n8n /home/node/.n8n /home/node/.n8n

# Switch to the node user
#USER node

# Set the working directory
WORKDIR /home/node

# Expose the default n8n port
EXPOSE 5678

# Start n8n
CMD ["n8n"]