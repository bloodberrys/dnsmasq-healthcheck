    #!/bin/bash

    hc_endpoints="api.oyindonesia.com www.google.com"

    IFS=" " read -r -a endpoint <<< "$hc_endpoints"

    endpointlength=${#endpoint[@]}

    hostname_success_counter=0
    hostname_failed_counter=0

    is_dnsmasq_exist=$(netstat -tlnp | grep dnsmasq); # Pertama check proses "dnsmasq"
    if [ -z "${is_dnsmasq_exist}" ]; then
        exit 1;
    else
        check_nc=$(nc -uvz localhost 53 2>&1| grep open); # kedua check "netcat" port 53 dengan mode UDP
        if [ -z "${check_nc}" ];
        then
            exit 1;
        else
            for (( i = 0; i < endpointlength; i++)) # ketiga cek dig ke endpoint yang udah diinclude array tadi
            do
                cmd1="dig @localhost ${endpoint[$i]} A "
                cmd2="grep NOERROR"
                go=$(eval "$cmd1" | eval "$cmd2")
                if [[ -n "$go" ]]; then
                    hostname_success_counter=$((hostname_success_counter+1)); # count successnya
                else
                    hostname_failed_counter=$((hostname_failed_counter+1));
                fi
            done
            if [ $hostname_success_counter -eq 2 ]; then #kalo hostnamenya oke 2-2nya
                exit 0; # FINAL state: healthy
            else
                exit 1; # FINAL state: unhealthy
            fi
        fi
    fi
