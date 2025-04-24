# Use a Node.js Alpine image as the base
FROM node:18-alpine

# Install Python, pip, GraphicsMagick, and fontconfig
RUN apk add --no-cache python3 py3-pip graphicsmagick fontconfig

RUN mkdir -p /tmp/ig

RUN chmod 777 /tmp/ig

# Create a directory for custom fonts
RUN mkdir -p /usr/share/fonts/truetype/custom

# Copy the entire Roboto and Open Sans folders into the container
COPY Roboto /usr/share/fonts/truetype/custom/
COPY Open_Sans /usr/share/fonts/truetype/custom/

# Update the font cache
RUN fc-cache -fv

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Upgrade pip and install the required library inside the virtual environment
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install youtube-transcript-api

# Copy the n8n application files from the official n8n image
COPY --from=docker.n8n.io/n8nio/n8n /usr/local /usr/local
COPY --from=docker.n8n.io/n8nio/n8n /home/node/.n8n /home/node/.n8n

# Switch to the node user
USER node

# Set the working directory
WORKDIR /home/node

# Expose the default n8n port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
