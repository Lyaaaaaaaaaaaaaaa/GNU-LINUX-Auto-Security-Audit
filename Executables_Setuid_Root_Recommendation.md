| Executable                                   | Comment                                                                      |
|----------------------------------------------|------------------------------------------------------------------------------|
| /bin/mount                                   | To disable, unless absolutely necessary for users.                           |
| /bin/netreport                               | To disable.                                                                  |
| /bin/ping6                                   | (IPv6) Same as `ping`.                                                       |
| /bin/ping                                    | (IPv4) Remove setuid right, unless a program requires it for monitoring.     |
| /bin/su                                      | Change user. Do not disable.                                                 |
| /bin/umount                                  | To disable, unless absolutely necessary for users.                           |
| /sbin/mount.nfs4                             | To disable if NFSv4 is unused.                                               |
| /sbin/mount.nfs                              | To disable if NFSv2 / 3 is unused.                                           |
| /sbin/umount.nfs4                            | To disable if NFSv4 is unused.                                               |
| /sbin/umount.nfs                             | To disable if NFSv2 / 3 is unused.                                           |
| /sbin/unix_chkpwd                            | Check the user password for non-root programs. To disable if notused.        |
| /usr/bin/at                                  | To disable if `atd` is not used.                                             |
| /usr/bin/chage                               | To disable.                                                                  |
| /usr/bin/chfn                                | To disable.                                                                  |
| /usr/bin/chsh                                | To disable.                                                                  |
| /usr/bin/crontab                             | To disable if `cron` is not required.                                        |
| /usr/bin/fusermount                          | To disable unless users need to mount partitions FUSE.                       |
| /usr/bin/gpasswd                             | To disable if no group authentication.                                       |
| /usr/bin/locate                              | To disable. Replace with `mlocate` and `slocate`.                            |
| /usr/bin/mail                                | To disable. Use a local mailer as `ssmtp`.                                   |
| /usr/bin/newgrp                              | To disable if no group authentication.                                       |
| /usr/bin/passwd                              | To disable, unless non-root users must be able to change their password.     |
| /usr/bin/pkexec                              | To disable if PolicyKit is not used.                                         |
| /usr/bin/procmail                            | To disable unless `procmail` is required.                                    |
| /usr/bin/rcp                                 | Deprecated. To disable.                                                      |
| /usr/bin/rlogin                              | Deprecated. To disable.                                                      |
| /usr/bin/rsh                                 | Deprecated. To disable.                                                      |
| /usr/bin/screen                              | To disable.                                                                  |
| /usr/bin/sudo                                | Change of user. Do not disable.                                              |
| /usr/bin/sudoedit                            | Same as `sudo`.                                                              |
| /usr/bin/wall                                | To disable.                                                                  |
| /usr/bin/X                                   | To disable unless the X server is required.                                  |
| /usr/lib/dbus-1.0/dbus- daemon-launch-helper | To disable when D-BUS is not used.                                           |
| /usr/lib/openssh/ssh- keysign                | To disable.                                                                  |
| /usr/lib/pt_chown                            | To disable (allows to change the owner of PTY before the existenceof devfs). |
| /usr/libexec/ utempter/utempter              | To disable if the utempter SELinux profile is not used.                      |
| /usr/sbin/exim4                              | Disable if Exim is not used.                                                 |
| /usr/sbin/suexec                             | Disable if `suexec` Apache is not used.                                      |
| /usr/sbin/traceroute                         | (IPv4) Same as `ping`.                                                       |
| /usr/sbin/traceroute6                        | (IPv6) Same as `ping`.                                                       |
