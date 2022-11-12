#!/bin/bash

white="(tput setaf 255)"
orange="(tput setaf 202)"
yellow="(tput setaf 011)"
red="(tput setaf 001)"
green="(tput setaf 028)"
bot="$orange[Assistente SafeCommerce]:$white"

versao_alvo_java=11
jar_gui="SafeCommerce-client-1.0-SNAPSHOT-jar-with-dependencies.jar"
url_jar_gui="https://raw.githubusercontent.com/CCO-SafeCommerce/SafeCommerceClient-Java/main/SafeCommerce-client/target/$jar_gui"

erro_setup_java=0
setup_java(){
    while [ $erro_setup_java -eq 0 ]; do
        which java | grep -q /usr/bin/java

        versao_java=0
        if [ ! $? == 0 ]; 
            versao_java=$(java -version)
        fi

        if [ $versao_java -ne $versao_alvo_java ]; then
            if [ $versao_java -eq 0 ]; then
                echo "$bot$yellow AVISO!!!$white Não encontramos o Java instalado na sua máquina."
            else
                echo "$bot$green SUCESSO!!!$white Encontramos o Java na sua máquina na versão $versao_java"
                echo "$bot Para o correto funcionamento, é necessária a versão $versao_alvo_java"
            fi
            
            echo "$bot Iniciando processo de instalação do Java versão $versao_alvo_java."
            echo "$bot Verificando se zip está instalado..."
            sleep 2

            if [ ! command -v zip &> /dev/null ]; then
                echo "$bot$red FALHA!!!$white zip não foi encontrado!"
                echo "$bot Instalando zip..."
                sleep 2

                sudo apt install zip

                if [ ! command -v zip &> /dev/null ]; then
                    erro_setup_java=1
                    break
                fi
            else
                echo "$bot$green SUCESSO!!!$white O zip está instalado"
            fi                

            echo "$bot Verificando se SDKMAN já está instalado..."
            sleep 2

            if [ ! command -v sdk &> /dev/null ]; then
                echo "$bot$yellow AVISO!!!$white SDKMAN não foi encontrado!"
                echo "$bot Adicionando caminho do SDKMAN ao Curl..."
                sleep 2

                curl -s "https://get.sdkman.io" | bash                            
                source "/home/$USER/.sdkman/bin/sdkman-init.sh"

                if [ ! command -v sdk &> /dev/null ]; then
                    erro_setup_java=2
                    break
                fi
            else
                echo "$bot$green SUCESSO!!!$white O SDKMAN já está instalado! Rodando limpeza de cache..."
                sdk update
            fi

            echo "$bot Instalando o Java versão 11..."
            sleep 2

            sdk install java 11.0.12-open

            versao_java=$(java -version)
            if [ $versao_java -eq $versao_alvo_java ]; then
                echo "$bot$green SUCESSO!!!$white O Java foi instalado com sucesso na versão correta!"
                erro_setup_java=-1
            else
                erro_setup_java=3
                break
            fi               
        else
            echo "$bot$green SUCESSO!!!$white Você já possui o Java instalado na versão correta (Java $versao_alvo_java)"
            erro_setup_java=-1
        fi
    done
}

instalar_jar_gui(){
    echo "$BOT$GREEN SUCESSO!!!$WHITE Todas as depedências necessárias para a aplicação funcionar foram instaladas com sucesso"
    echo "$BOT Instalando aplicação de coleta para monitoramento da máquina"
    sleep 2

    wget $url_jar_gui
    if [ -e $jar_gui ]; then
        echo "$BOT$GREEN SUCESSO!!!$WHITE Aplicação de coleta em Java com GUI foi instalada com sucesso!"
    else
        echo "$BOT$RED FALHA!!!$WHITE Não foi possível instalar a aplicação!"
    fi
}

echo "$bot Bem vindo ao assistente de instalação da aplicação de coleta para o monitoramento do servidor!"
echo "$bot Qual(is) versões da aplicação você gostaria de instalar: (Recomendamos instalar todas, pois algumas métricas só são coletadas por uma das aplicações)"
echo "$bot [1] - Python"
echo "$bot [2] - Java GUI"
echo "$bot [3] - Ambos"
echo "$bot [0] - Cancelar instalação"
read opt_inst

if [ $opt_inst -ne 0 ]; then
    if [ $opt_inst -eq 1 ]; then
        echo "$bot Você escolheu instalar apenas a aplicação em Python"
        echo "$bot$yellow ATENÇÃO!!!$white Algumas métricas podem não ser coletadas, confira no nosso site o que a aplicação Python é capaz de monitorar"
        echo "$bot$yellow ATENÇÃO!!!$white Algumas instalações são necessárias para que a aplicação Python funcione. Você aceita essas instalações? (S\N)"        

    elif [ $opt_inst -eq 2 ]; then
        echo "$bot Você escolheu instalar apenas a aplicação em Java com GUI"
        echo "$bot$yellow ATENÇÃO!!!$white Algumas métricas podem não ser coletadas, confira no nosso site o que a aplicação Java com GUI é capaz de monitorar"
        echo "$bot$yellow ATENÇÃO!!!$white Algumas instalações são necessárias para que a aplicação Java com GUI funcione. Você aceita essas instalações? (S\N)"
        
    elif [ $opt_inst -eq 3 ]; then
        echo "$bot Você escolheu instalar ambas as aplicações"
        echo "$bot$yellow ATENÇÃO!!!$white Algumas instalações são necessárias para que as aplicações funcionem. Você aceita essas instalações? (S\N)"
    fi
    
    read autorizacao_inst
    if [ \"$autorizacao_inst\" == \"S\" ]; then
        if [ $opt_inst -eq 1 ]; then
            setup_python
            instalar_api_py

        elif [ $opt_inst -eq 2 ]; then
            setup_java
            instalar_jar_gui

        elif [ $opt_inst -eq 3 ]; then
            setup_python
            instalar_api_py
            setup_java
            instalar_jar_gui
        fi

    else
        echo "$bot Você não autorizou a instalação de configuração. Não será possível instalar a aplicação de monitoramento!"
    fi
else
    echo "$bot Você optou por cancelar a instalação. Não será possível instalar a aplicação de monitoramento!"
fi

echo "$bot Obrigado por utilizar nossos serviços!"
