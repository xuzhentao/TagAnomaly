FROM rocker/shiny:3.6.1

RUN apt-get update &&\
   apt-get install build-essential libcurl4-gnutls-dev libv8-3.14-dev libssl-dev libxml2-dev libgit2-dev -y &&\
   mkdir -p /var/lib/shiny-server/bookmarks/shiny


RUN R -e "install.packages('devtools')"

RUN R -e "install.packages(c('shiny', 'shinydashboard','DT','dplyr','ggplot2','gridExtra','shinythemes','parsedate','remotes'), repos='http://cran.rstudio.com/')" && \
    R -e "remotes::install_github('twitter/AnomalyDetection')"

COPY taganomaly /root/app
COPY Rprofile.site /usr/local/lib/R/etc/Rprofile.site

# make all app files readable (solves issue when dev in Windows, but building in Ubuntu)
RUN chmod -R 755 /root/app
RUN chmod -R 755 /usr/local/lib/R/etc

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/app')"]
