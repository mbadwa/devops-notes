## How to Generate a Public/Private Key Pair

Before You Begin

Determine from your system administrator if host-based authentication is configured.

1. Start the key generation program.
   
        ssh-keygen -t rsa

    where -t is the type of algorithm, one of rsa, dsa, or rsa1
2. Specify the path to the file that will hold the key.

    By default, the file name id_rsa, which represents an RSA v2 key, appears in parentheses. You can select this file by pressing the Return key. Or, you can type an alternative file name.

        Enter file in which to save the key (/home/jdoe/.ssh/id_rsa):<Press Return>

    The file name of the public key is created automatically by appending the string .pub to the name of the private key file.
3. Type a passphrase for using your key.
   
   This passphrase is used for encrypting your private key. A null entry is **strongly discouraged**. Note that the passphrase is not displayed when you type it in.

        Enter passphrase (empty for no passphrase): <Type passphrase>

4. Retype the passphrase to confirm it.

        Enter same passphrase again: <Type passphrase>
        Your identification has been saved in /home/jdoe/.ssh/id_rsa.
        Your public key has been saved in /home/jdoe/.ssh/id_rsa.pub.
        The key fingerprint is:
        0e:fb:3d:57:71:73:bf:58:b8:eb:f3:a3:aa:df:e0:d1 jdoe@myLocalHost
5. Check the results.
   
         ls ~/.ssh
    At this point, you have created a public/private key pair.

6. Choose the appropriate option:


        cat ~/.ssh/id_rsa.pub | ssh <user>@<hostname> 'cat >> .ssh/authorized_keys && echo "Key copied"'

        or

        ssh-copy-id devops@remote-server-ip-address


## References

1. [Jenkins Deep Dive - Section: Slave Node Setup](/General-notes/Jenkins-notes/jenkins-deep-dive.md)