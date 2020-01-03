Oftentimes, it could be convenient to transfer images from a phone to a computer via a script (or vise versa). An example would be a real-time computer vision demo that uses the phone's camera, but performs the computations elsewhere. Despite the relatively enclosed nature of mobile operating systems, there are two methods that work relatively well for Android phones.

## Termux & SSH method
Android does not offer remote shell access natively, yet it is possible to achieve a near alternative with Termux, a Linux emulator for Android. However, the Termux camera utility appears to be suffering an ongoing glitch for some models, giving very darkly-exposed images that are essentially unusable. Your mileage may vary.

### Install Termux and Termux:API
Both apps are open source and freely available on the Play Store. Termux is the Linux emulator itself, while Termux:API allows for command-line access of the phone's hardware features.
<div class="inline-image">
<img src="/imgs/2-1.jpg" height="250" alt="Termux app">
<img src="/imgs/2-2.jpg" height="250" alt="Termux API app">
</div>
Make sure camera permission is granted for the Termux:API app.

### Enable SSH
Open Termux, and in the shell that pops up, we install open-ssh.
```
apt install open-ssh
```
Then, we use the sshd command to start the SSH daemon, effectively turning the phone into an SSH server.
```
sshd
```
### Add a public key
Password authentication is not available in Termux, and for better or worse, key authentication is the only option.
On the computer that will be used to connect to the phone, find the public key (~/.ssh/id_rsa.pub for Linux/Mac), and send it to the phone.
On the phone, copy the public key into authorized_keys
```
vi authorized_keys
```
<div class="inline-image">
<img src="/imgs/2-5.jpg" height="350" alt="Authorized keys file">
</div>
If you are unfamiliar with the vi editor, press i before pasting, and then esc to exit editing mode, before entering :wq to exit the editor.
Now, the computer has authorization to access Termux remotely.
### Test the connection
Next, we find the phone's ip address with the ifconfig command, and find the username for the Termux container
```
ifconfig
whoami
```
![Phone ip address](/imgs/2-3.jpg)
In my case, the phone's local ip address is 10.0.0.244, and the username is u0_a213
Now, we can test the SSH connection, bearing in mind that the default port is 8022
```
ssh -p 8022 u0_a213@10.0.0.244
```
SFTP should work in a similar fashion
```
sftp -P 8022 u0_a213@10.0.0.244
```
### Automating
Now, we compact the SSH and SFTP retrieval process into a shellscript.

![Auto retrieval script](/imgs/2-7.png)

\* Here's a [guide on Termux SSH](https://glow.li/technology/2015/11/06/run-an-ssh-server-on-your-android-with-termux/) that helped me a lot.

## FTP server method
If manually taking the picture with the phone is an option, then an FTP script could be used to retrieve the newly taken image to the computer.
### Install an FTP server app
In this configuration, the phone acts as an FTP server, and an application should be installed accordingly.
I personally use this one:
<div class="inline-image">
<img src="/imgs/2-4.jpg" height="200" alt="FTP server app">
</div>
### Configure the FTP app
The process may vary between apps, but in general, three things should be set up before the app is ready.
* The port number to run on
* The login username and password
* The desired keep-alive time for the connection

### Python script
Most programming languages provide libraries for the FTP protocol, but I'll use Python as an example here.
The documentation for Python's ftplib is [here](https://docs.python.org/3/library/ftplib.html).
Generally, the Python script to perform the retrieval consists of four steps:
1. Create the FTP instance
2. Log in to the FTP server of the phone
3. List the contents of the desired directory
4. Perform the retrieval on the specified file
![Python download script](/imgs/2-6.png)

