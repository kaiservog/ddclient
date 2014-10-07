#!/bin/bash

echo "*** DDClient Build! ***"
echo "generating JS files"

coffee --compile --output /home/kaiservog/Dev/ddclient/target ./

echo "JS genereted, copying js files to sever"

cp -r /home/kaiservog/Dev/ddclient/target/* /srv/http

cp ./*.htm /srv/http
cp -r ./lib/* /srv/http/lib

echo "** Finalizado **"
