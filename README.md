sinch
=====

sinch is Site INtegrity CHecker. It's the bash script that gets current state of the sites by FTP using lftp and compares it to master copy using diff. It's intended to run periodically by cron. Warning: never run it as a privileged user, it uses FTP mirroring and can wipe your filesystem out in case of error.
