FROM rocker/r-base:4.2.1

# Setup dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*
RUN install.r remotes shiny

# Setup app
WORKDIR /home/app
COPY DESCRIPTION .
RUN R -e "remotes::install_deps()"
COPY . .

CMD ["R", "-e", "shiny::runApp('/home/app')"]
