#Introduction and course setup

Welcome to the class! Setting up a Linux environment is required for the course, and that is your first task should you choose to accept it.
Use this as an opportunity to introduce yourself, get your feet wet with the email patch submission process we will use for this class.

### Outcomes:
* Set up your Linux environment for the rest of the class.
* Get familiar with git and git patches.
* Get familiar with how to submit to the mailing list (`git send-email`).
* Get familiar with the peer review process, which we will use for the rest of the course.

### Procedure:

#### Set up your VM and Linux environment

##### Get the appropriate software

* Start downloading the standard ISO image for Fedora for your architecture.
  * You probably want the ISO for x86\_64, unless you have an M1 Mac or you are running Linux on ARM, in which case you want the aarch64 ISO.
* This may take a while depending on your internet speed. <https://getfedora.org/en/server/download/>.

* Download and install hypervisor software for your operating system
  * Windows - [VirtualBox](https://www.virtualbox.org/wiki/Downloads):
    * Click the download link for Windows hosts.
  * MacOS - [UTM](https://mac.getutm.app/):
    * You don't need to buy it from the App Store for (they charge $10 for it there),
      there is a free download that is identical but you have to install it yourself (press the download button at the above link).
  * Linux - [virt-manager](https://virt-manager.org/):
    * You can most likely get it from your system's package manager.

##### Figure out how many resources to give your VM
* Depending on how powerful your machine is, you can give it more or less.
  * Generally, leave at least half of the cores and RAM for your host system.
    * The more you can give the VM the better.
  * For the class you will need at least 30G of hard-disk space to hold the VM.
* Balance it how you want. Feel free to reach out for specific advice, depending on the specs of your machine.

##### Set up the VM
* Once the ISO image has finished downloading, you can begin the VM set-up process.
* Depending on the software you downloaded, the exact procedure will vary.
  However, you want to create a new virtual machine guest and set the resources to the values you decided to allocate.
  Most likely just follow the set-up wizard of your software and it will guide you.
  Make sure to create a virtual hard drive for the machine (at least 30G is suggested).
* Attach the ISO image to the machine, this will allow it to boot into the Fedora live environment.
* Start the VM for the first time and it will boot the Fedora ISO image.

##### Install Fedora to your virtual machine
* Once it boots you will see a grub menu with two options "test this media and install fedora" and "install fedora"
  * You can select either one, testing the media will verify that your ISO downloaded correctly, but it will take longer.
* Once the actual operating system boots, the anaconda installer should open automatically.
* Mostly follow the on-screen instructions to install fedora on to your VM's harddrive.
* However, there may be some confusing steps. If you get stuck, there are numerous tutorials online on how to proceed based on the VM software you are using.
* There are two settings you have to adjust before you can start the installation, the root password, and the installation destination.
* Click on root password and setup the root account with a password you will remember then click done.
* Next, this particular step where you have to set the "Installation Destination", depicted below, is especially confusing.
  The installation destination icon will have a red warning triangle, to proceed, click on the icon and it will open the screen below. Just click "Done",
  you don't need to change anything---it just wants you to confirm the default hard-drive and partitioning selections it has made.

<div id="confusion"><img alt="fedora confusion image" src="/images/fedora_confusion.png"></img></div><br>

* Once the installation has finished, Fedora will tell you to reboot. Shut down the machine and remove the ISO image from where you attached it to the VM
  (once this is done and you confirmed the installation was successful, you can remove the ISO image from your host machine to free up disk space).
* Boot the VM and you should be greeted with a Fedora login prompt, use the username "root" and then enter the root password you selected during installation
  (it won't look like you are typing any characters when you enter the password, but they are being received, and hiding them is just a security measure).
* If you logged in correctly, you should be greeted with a command prompt that looks something like:

```
[root@localhost ~]# _
```

If you see this, you have completed the basic installation of Fedora correctly. Congrats!

##### Post Install Setup
* Set a hostname for the machine:
  * Login with your root account.
  * Pick a hostname for the machine (e.g. `joels-fedora-vm`)
  * Run the command `echo hostname > /etc/hostname` where you replace *hostname* with the name you picked.
  * Run the command `hostname --file /etc/hostname` to update it for this boot without needing to restart the machine.
  * Log out and the login prompt will include the new hostname before the word login (e.g. `joels-fedora-vm login: _`
* Run a software update:
  * Login with your root account.
  * Run the command `dnf update`, (this may take a while to complete.)
  * While you are waiting you can switch to a different console and continue following the steps.
    * Press `ctrl+alt+f2` (on some keyboards you might need a function key to press f2).
    * You can check back on the update any time by pressing `ctrl+alt+f1`.
* Create yourself a non-root account with sudo permissions.
  * Login to the other console as root.
  * Pick a username (e.g. `jsavitz`) for your account.
  * Run the command `useradd username` where *username* is the username you picked.
  * Run the command `usermod -aG wheel username` to give the new user permission to run commands as the superuser (root).
  * Run `passwd username` and select a password.
  * Log out of root (type `exit` or hit `ctrl+d`).
  * Try logging in as your new user with the username and password you selected.
  * Verify that you have root access via running `sudo whoami`, you should be prompted for a password
   and when you enter your password the `whoami` command should execute and output `root`.

#### Configure your account for the class email system and send your first email patches

* Login as your non root user account
* Install `git` and `git-email`. Run `sudo dnf install -y git git-email`.
* Configure your `.gitconfig`, which lives in `~/.gitconfig`, using a text editor (e.g. `nano ~/.gitconfig` or `vi ~/.gitconfig`).
    * You can pick your default editor by adding: <pre><code>[core]
        editor = nano # Or which ever editor you prefer
</code></pre>
    * Set your identity and account information by adding: <pre><code>[user]
		name = Your Name Here
		email = YOUR_USERNAME@kdlp.underground.software
[sendemail]
		smtpUser = YOUR_USERNAME
		smtpPass = YOUR_PASSWORD
		smtpserver = kdlp.underground.software
		smtpserverport = 465
		smtpencryption = ssl
</code></pre>
    * Make sure to fill in the fields with your username and password (the ones you use to log into the website)
* Clone [the assignment git repository](https://kdlp.underground.software/cgit/ILKD_assignments/): Run `git clone https://kdlp.underground.software/cgit/ILKD_assignments/`.
* Change directory into the `introductions` folder within the repository.
* There are already introductions from the instructors in there, read them to see an example of what to do.
* Add a file named `firstname_lastname.txt` (e.g. `joel_savitz.txt`), containing an introduction about yourself
    * The content can be whatever you want, whether it be why you are taking this class, your favorite ice cream flavor, or a fun fact about yourself.
* Run `uname -a >> firstname_lastname.txt` to append a line with information about the VM environment you set up to the end of your introduction file.
* Make a commit out of your changes.

#### Check your work
* While Logged in as your non root user account
* Install `mutt` a terminal program for viewing email. Run `sudo dnf install -y mutt`
* Configure your `.muttrc` which lives in `~/.muttrc`, using a text editor (e.g. `nano ~/.muttrc` or `vi ~/.muttrc`).
    * Set your identity and account information by adding: <pre><code>set realname='Your Name Here'
set my_username="YOUR_USERNAME"
set my_password="YOUR_PASSWORD"
</code></pre>
    * Set some sane defaults, and configure the server addresses by adding: <pre><code>set spoolfile=
set record=
set sort=threads
set from="$my_username@kdlp.underground.software"
set smtp_url="smtps://$my_username:$my_password@kdlp.underground.software:465"
push "<change-folder>pops://$my_username:$my_password@kdlp.underground.software:995"\n
</code></pre>
* Open the email list by running the `mutt` command. You can quit by pressing `q` or hitting `ctrl+c`
* You will see a list of email threads navigate up and down with the arrow keys or `j` and `k`
* You should see a welcome to the email system message at the top and then all subsequent emails in chronological order.
* Press enter to view the selected message and press `q` to exit back to the main screen.
* You should see your patch series including your introduction in the list of messages.
* If you do, congratulations, you successfully completed the setup. You can shut down the VM and go do something else :)
* If not, feel free to reach out with questions we are happy to help.

#### Optional VM Configuration

* Set up SSH access:
  * Run the command `ip -br a | grep UP`, read the ip address listed there.
  * On your host machine, open a terminal and try running `ssh username@ip-address` where *username* is the username you picked earlier and the *ip-address* is the one you just found.
  * You should be prompted for your password, after you enter it you will be able to access your vm from your host machine.
  * If you want to obviate the need to enter the password every time you log in, you can set up SSH-keys.
  * Open a terminal on your host machine (`cmd.exe` on windows)
    * If you have never set up SSH-keys (you might have done it already if you use ssh for github or gitlab):
      * Run the command `ssh-keygen` in a terminal on your host machine and accept the default values.
    * If you already have SSH-keys or you just created them using the step above:
      * If you are not on Windows, run `ssh-copy-id username@ip-address` to copy your keys to the VM.
      * If you are on Windows, run `type $env:USERPROFILE\.ssh\id_rsa.pub | ssh username@ip-address "cat >> .ssh/authorized_keys"`
      * You will be prompted for your password, enter it, and the command should finish.
      * Try logging in with `ssh username@ip-address` and you should not need to enter your password again.
* Make the VM headless:
  * Check back on the updates from the first step. Wait for them to finish.
  * Once the updates are finished, run `shutdown now`. The VM should shut down and exit.
  * Open the VM Settings and disable the graphical output, the exact settings depends on the VM software you are using.
  * Most of the time you will be able to keep the graphics off, since you already set up SSH access.
  * This will lighten the load on your computer since it won't have to render the GUI and will make the VM run faster.



### What to submit:
* Generate a patchset from your commit with a cover letter.
* Send the patchset to introductions@kdlp.underground.software.

[Submission Guidelines](../policies/submission_guidelines.md)
