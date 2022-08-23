FROM ubuntu:18.04

# Setup dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    sudo \
    build-essential \
    dirmngr \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libxml2-dev \
    software-properties-common \
    wget \
    && rm -rf /var/lib/apt/lists/*
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | \
    tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN apt-get install -y --no-install-recommends r-base
RUN R -e "install.packages(c('shiny', 'remotes'))"

# Setup app
WORKDIR /home/app
COPY DESCRIPTION .
RUN R -e "remotes::install_deps()"
COPY . .

CMD ["R", "-e", "shiny::runApp('/home/app', port=8000, host='0.0.0.0')"]
