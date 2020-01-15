#!/bin/bash

# simple imap check, bash only                                                  
                                                                                
SERVER="imap.foobar.net"                                                     
                                                                                
echo "1 login username password" > /tmp/checkmail                                 
echo "2 select inbox" >> /tmp/checkmail                                         
echo "3 logout" >> /tmp/checkmail                                               
                                                                                
response=$(openssl s_client -crlf -connect $SERVER:993 -quiet 2> /dev/null < /tmp/checkmail)
rm /tmp/checkmail                                                               
                                                                                
news=$(echo "$response" | grep RECENT | awk '{print $2}')                       
last=$(echo "$response" | grep EXISTS | awk '{print $2}')                       
                                                                                
echo "$last messages, $news new"                                                
                                                                                
if [ "$news" != "0" ]                                                           
then                                                                            
for (( i=0; i<$news; i++))                                                      
do                                                                              
    echo "fetching $i° message"                                                 
    echo "1 login myusername mypassword" > /tmp/getmail                         
    echo "2 select inbox" >> /tmp/getmail                                       
    echo "3 fetch $((last-i)) (body[1])" >> /tmp/getmail                        
    echo "4 logout" >> /tmp/getmail                                             
    response=$(openssl s_client -crlf -connect $SERVER:993 -quiet 2> /dev/null < /tmp/getmail)
    rm /tmp/getmail                                                             
                                                                                
    content=$(echo "$response" | awk '/FETCH/{flag=1;next}/3 OK Success/{flag=0}flag')
    notify-send -t 0 "New message" "$content"                                   
done                                                                            
fi                                                                              
                                                                                
