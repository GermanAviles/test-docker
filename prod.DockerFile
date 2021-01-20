
########################################
##  _           _  _     _            ##
## | |__  _  _ (_)| | __| | ___  _ _  ##
## | '_ \| || || || |/ _` |/ -_)| '_| ##
## |_.__/ \_,_||_||_|\__,_|\___||_|   ##
########################################

#base image
FROM node:14.15.4-slim as build
# MAINTAINER German Aviles<german.aviles06@gmail.com>

#set working directory
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

#add `/usr/src/app/node_modules/.bin` to $PATH
# ENV PATH /usr/src/app/node_modules/.bin:$PATH

#Install and cache app dependencies
COPY package.json package-lock.json ./
RUN npm install


#add app
COPY . /usr/src/app
RUN npm install -g @angular/cli@11.0.7

#Generate build
RUN ng build

############################
##                     _  ##
##  _ __  _ _  ___  __| | ##
## | '_ \| '_|/ _ \/ _` | ##
## | .__/|_|  \___/\__,_| ##
## |_|                    ##
############################
# base image
# nginx:1.19.6-alpine
FROM nginx:stable-alpine

# copy artifact build from the 'build environment'
COPY nginx.conf /etc/nginx/nginx.conf
# COPY --from=build /usr/src/app/dist/test-docker /usr/share/nginx/html
# COPY default.conf /etc/nginx/conf.d/default.conf
COPY dist/test-docker /usr/share/nginx/html

#expose port 80
EXPOSE 80

#run nginx
# CMD ["nginx", "-g", "daemon off;"]
