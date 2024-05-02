#!/bin/bash
function list_all(){

    echo "#Productos"
    apic products:list-all  -s https://localhost:2000 -c sandbox -o localtest --scope catalog 

    echo "#APIs"
    apic apis:list-all      -s https://localhost:2000 -c sandbox -o localtest --scope catalog 

    echo "#Subscriptions_Plans"
    apic subscriptions:list -s https://localhost:2000 -c sandbox -o localtest --scope catalog 

    echo "#Aplicaciones"
    apic apps:list          -s https://localhost:2000 -c sandbox -o localtest --scope catalog 

    echo "#Organizaciones_consumidoras"
    apic consumer-orgs:list -s https://localhost:2000 -c sandbox -o localtest

}

CHECK_USER_LOGGED=$(apic products:list-all  -s https://localhost:2000 -c sandbox -o localtest --scope catalog)

if [[ "$CHECK_USER_LOGGED" == *"Error: Unauthorized"* ]]; then
    echo "Usuario debe loguearse usando apic cli"
else
    list_all | column -t
fi
