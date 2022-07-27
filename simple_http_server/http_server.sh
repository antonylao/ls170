#!/bin/bash

# test your solution by executing http_server.sh in one terminal window, connecting to the server in separate 'client' window and sending some messages.
#bash code for client: nc -v localhost 2345

function server () {
  while true
  do
    message_arr=()
    check=true
    while $check
    do
      read line
      message_arr+=($line)
      if [[ "${#line}" -eq 1 ]] # browsers use `\r\n` to simulate a newline, which usually have a length of 1 (content of line would be `\r`) (from https://launchschool.com/posts/e2b606d5#comment-76781)
      then
        check=false
      fi
    done

    method=${message_arr[0]}
    path=${message_arr[1]}
    if [[ $method = 'GET' ]]
    then
      if [[ -f ./www/$path ]]
      then
        length_body=$(wc -c < ./www/$path)
        echo -en "HTTP/1.1 200 OK\r\n"
        echo -en "Content-Type: text/html; charset=utf-8\r\n"
        echo -en "Content-Length: $length_body\r\n"
        echo -en "\r\n"
        cat ./www/$path #; echo -en "\r\n"
      else
        echo -en "HTTP/1.1 404 Not Found\r\n"
        echo -en "Content-Length: 0\r\n"
        echo -en "\r\n"
      fi
    else
      echo -en "HTTP/1.1 400 Bad Request\r\n"
      echo -en "Content-Length: 0\r\n"
      echo -en "\r\n"
    fi
  done
}

coproc SERVER_PROCESS { server; }
# the coprocess SERVER_PROCESS runs our server function asynchronously alongside our netcat command


nc -klv 8080 <&${SERVER_PROCESS[0]} >&${SERVER_PROCESS[1]}
# takes the input from the netcat process and redirects it to SERVER_PROCESS, which passes it to the input (STDIN) of the server function as part of the functionality of the coprocess. The output (STDOUT) of the server function, which is automatically passed to SERVER_PROCESS as part of the functionality of the coprocess, is redirected to the output of netcat
# => any input that netcat receives (for example a request message from a client) can be accessed within the server function using the `read` command, and anything that the server function outputs using `echo` will be output by netcat
# NB: the -k option forces netcat to stay listening for another connection after its current connection is completed.