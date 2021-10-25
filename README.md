Code to reproduce [this issue](https://serverfault.com/q/1081172/66928),
which is that all of `tee`'s output isn't making it into the system
journal.

# Setup

```
git clone https://github.com/mgalgs/systemd-tee-output-issue.git
cd systemd-tee-output-issue
cp tee_test.sh /usr/local/bin  # might need sudo
mkdir -pv ~/.config/systemd/user
cp tee_test.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user start tee_test.service
journalctl --user -xf -u tee_test.service
```

You'll see in the logs that some of our pizza is missing, though the pie is
all there.
