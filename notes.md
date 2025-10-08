First step of creating a linux setup script is the file structure, we need a place to store scripts, a place where we can have output logs, configs for SSH config/hostname files/etc., then we will have our setup.sh which is our main script file and ofc a README

before just writing code, its good to understand the order of operations. Why?
1. Set hostname         System identity comes first
2. set timezone         System time affects the logs, SSH,etc
3. Install packages     You may need packages before user setup
4. Create users         You want to create user with correct shell/tools available
5. Configure SSH        Done last, since user & packages setup may affect it




then after building the setup, we build the VM on whatever VM machine you use, I use VirtualBox. 


Bridge adapter for the VM, why do this, is this a secure method?

Using a bridge adapter is actually smart for this case. Here is why:

    > You can ssh from you host machine into your VM
    > There isn't any port forwarding nonsense, unlike NAT
    > Works just like a real machine on your LAN

So for testing and learning this is great but good to note its not so great for: Corporate laptop on company Wi-Fi, Running production-like services, Working with sensitive data. Even though i've ever ran into any of these issues, it's still great to understand and know about these real-world cases where you can fuck up.





Checking everything works after setup:

1. we can check hostname with the ```hostnamectl``` command

2. we can check the timezone using  ```timedatectl```

3. Installed packages using ```which vim curl git ufw htop```

    > The script is written to install only these specific essential tools for basic sysadmin tasks. That’s why which only shows paths for these — we didn’t install anything else. If we added more packages to the list, they would show up too.

4. User creation ```id newadmin``` or the home dir and shell ```getent passwd newadmin```

    > id newadmin tells you the UID(user ID), GID(Groups ID), and all groups the user is install
    
    > id shows the internal numeric IDs for the user newadmin, plus their group memberships. These IDs control what files and actions the user has access to.

    > getent passwd pulls user account data from the system’s database. It tells me the user’s home folder, default shell, and internal system ID, which helps verify that the user is configured correctly.

5. Check the sshd_config file ```grep -E 'PermitRootLogin|PasswordAuthentication' /etc/ssh/sshd_config```

   Then check SSH service status:
    ```sudo systemctl status ssh || sudo systemctl status sshd```
    
    > Why run the grep command? This checks if your script successfully hardened SSH security. This command checks the SSH configuration file to make sure we’ve disabled root login and password-based login. This is a basic hardening step to reduce the risk of brute-force attacks.

    > On Ubuntu, the service is named ssh and on RedHat/CentOS, it’s often sshd so checking both makes your script cross-platform aware.
    
    *Why?*
    > After modifying the SSH config file, we check the SSH service to ensure it’s still running. If the config was broken, it would fail to restart. By checking systemctl status, we make sure SSH is live and accepting secure connections.

=========
mkdir -p linuxSetup-scripts in your virtual machine

copying over the files to your VM using: ```scp -r ~/linuxSetup-script daddy_bash@<your.vm.ip>:~```

cd into your project root inside the vm and run `ls`, make the script setup.sh executable if its in there and then run it with ./setup.sh
