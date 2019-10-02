# Defines the image to be used
FROM swift:5.0.3

# Installs open-ssl since swift-NIO version 1 needs it (vapor 3 runs on NIO v1)
RUN apt-get -qq update && apt-get install -y \
  libssl-dev zlib1g-dev \
  && rm -r /var/lib/apt/lists/*

# Defines our working directory
WORKDIR /app

# Copy our working directory to the container
COPY . ./

# Runs those commands at build time to fetch and resolve all SPM dependencies
RUN swift package resolve
RUN swift package clean

# Declare this command to be run at uptime (when the container will be spawn)
CMD ["swift", "test"]
