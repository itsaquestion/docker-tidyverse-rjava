# Base image, see https://hub.docker.com/r/rocker/rstudio
FROM rocker/tidyverse:3.5.3

# Shiny
RUN export ADD=shiny && bash /etc/cont-init.d/add

# Install java and rJava
RUN apt-get -y update && apt-get install -y \
   default-jdk \
   r-cran-rjava \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/

# Install ODBC stuff
RUN apt-get -y update && apt-get install -y --install-suggests \
   unixodbc unixodbc-dev \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/

# Install further R packages
RUN install2.r --error --deps TRUE \
   RJDBC \
   odbc \
   RMariaDB \
#   RPostgres \
   && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# chinese fonts
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    # fonts-wqy-zenhei \
    # fonts-noto \
    fonts-noto-cjk \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get -qyy clean

RUN install2.r --error --deps TRUE \
   devtools \
   shinycssloaders \
   pool \
   egg \
   shinythemes \
   properties \
   lattice \
   xts \
   && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# for ggalt
RUN install2.r --error --deps TRUE \
   KernSmooth \
   MASS \
   && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN R -e 'devtools::install_github("hrbrmstr/ggalt", ref = "noproj")'
RUN R -e "install.packages(c('DBI','RPostgres'), repos='http://cran.r-project.org')"
RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds
