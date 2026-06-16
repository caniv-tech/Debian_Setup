# Debian_Setup

These Bash scripts automates the setup process for a Debian system. Currently for Debian 12 - Bookworm but will be updated for new versions. 

## Prerequisites

- A fresh installation of Debian.
- Access to a user account with root privileges.

**Important:** If you assigned a password to the root account during the Debian installation, your regular user account may not have root privileges. To grant root privileges to your regular user, add the user to the `sudo` group as follows:

1. Install the `sudo` package:
   ```shell
   apt install sudo
   ```

2. Add your user to the `sudo` group:
   ```shell
   usermod -aG sudo <username>
   ```
   Replace `<username>` with your actual username.


## Disclaimer

Please use this script at your own risk. It is recommended to review the script and ensure it aligns with your system requirements before running it. We are not responsible for any damages or data loss caused by the use of this script.

