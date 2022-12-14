#!/bin/bash

cd

repo_site="https://github.com/CCO-SafeCommerce/safecommerce.git"
jar_gui="SafeCommerce-client-1.0-SNAPSHOT-jar-with-dependencies.jar"
url_jar_gui="https://raw.githubusercontent.com/CCO-SafeCommerce/SafeCommerceClient-Java/main/SafeCommerce-client/target/$jar_gui"
repo_python="https://github.com/CCO-SafeCommerce/API-Python.git"

echo "SetUp da EC2"
echo "Criando atualizando EC2"
sleep 2
sudo apt update && sudo apt upgrade

echo "Criando diretório do projeto"
sleep 2
mkdir projeto

cd projeto
echo "Clonando repositório do site"
sleep 2
git clone $repo_site
if [ -d "safecommerce" ]; then
    echo "Clonado com sucesso"
else
    echo "Falha no clone"
fi

echo "Clonando repositório do python"
sleep 2
git clone $repo_python

if [ -d "API-Python" ]; then
    echo "Clonado com sucesso"
else
    echo "Falha no clone"
fi

echo "Instalando docker.io"
sleep 2
sudo apt install docker.io

if [ $(command -v docker) == "/usr/bin/docker" ]; then
    sudo systemctl start docker
    sudo systemctl enable docker

    echo "Docker instalado com sucesso"

    echo "Obtendo imagem do MySQL"
    sleep 2
    sudo docker pull mysql:5.7

    echo "Criando container MySQL"
    sleep 2
    sudo docker run -d -p 3306:3306 --name "MySQLDocker" -e "MYSQL_ROOT_PASSWORD=urubu100" mysql:5.7
else
    echo "Falha na instalação do docker"
fi