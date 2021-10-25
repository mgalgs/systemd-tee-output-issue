Code to reproduce [this issue](https://serverfault.com/q/1081172/66928),
which is that all of `tee`'s output isn't making it into the system
journal.

# Setup

```
cp tee_test.sh /usr/local/bin
cp tee_test.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user start tee_test.service
journalctl --user -xf -u tee_test.service
```
