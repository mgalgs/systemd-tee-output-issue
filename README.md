Code to reproduce [this issue](https://serverfault.com/q/1081172/66928),
which is that some of `tee`'s output isn't making it into the system
journal.

# Repro instructions

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

# Test results

I've reproduced the issue on the following systems:

```
Manjaro
systemd 249 (249.4-2-manjaro)
+PAM +AUDIT -SELINUX -APPARMOR -IMA +SMACK +SECCOMP +GCRYPT +GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY +P11KIT -QRENCODE +BZIP2 +LZ4 +XZ +ZLIB +ZSTD +XKBCOMMON +UTMP -SYSVINIT default-hierarchy=unified

Ubuntu 20.04
systemd 245 (245.4-4ubuntu3.5)
+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid
```

I'm unable to reproduce the issue on the following systems:

```
Debian 11
systemd 247 (247.3-6)
+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +ZSTD +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=unified
```

I don't see any glaring difference between the working `Debian 11` config
and the non-working `Manjaro` config (`diff -r /etc/systemd ~/tmp/debian_systemd`)...

### Logs in system journal

Viewing with `journalctl --user -x -u tee_test.service`. I only see a subset of the logs.

```
Oct 20 09:49:03 grinchel systemd[2678]: Started Test teeing under systemd.
░░ Subject: A start job for unit UNIT has finished successfully
░░ Defined-By: systemd
░░ Support: https://forum.manjaro.org/c/support
░░
░░ A start job for unit UNIT has finished successfully.
░░
░░ The job identifier is 8193.
Oct 20 09:49:26 grinchel tee_test.sh[399363]: i shall eat 25 slices of pizza
Oct 20 09:49:40 grinchel tee_test.sh[400047]: i shall eat 39 slices of pizza
Oct 20 09:49:48 grinchel tee_test.sh[400430]: i shall eat 47 slices of pizza
Oct 20 09:49:49 grinchel tee_test.sh[400496]: i shall eat 48 slices of pizza
Oct 20 09:49:50 grinchel tee_test.sh[400529]: i shall eat 49 slices of pizza
Oct 20 09:49:51 grinchel tee_test.sh[400595]: i shall eat 50 slices of pizza
Oct 20 09:50:14 grinchel tee_test.sh[401790]: i shall eat 73 slices of pizza
Oct 20 09:50:27 grinchel systemd[2678]: Stopping Test teeing under systemd...
```

### Logs in log file

In my log file I see all of the logs.

```
i like pie
i shall eat 2 slices of pizza
i shall eat 3 slices of pizza
i shall eat 4 slices of pizza
i shall eat 5 slices of pizza
i shall eat 6 slices of pizza
i shall eat 7 slices of pizza
[...many similar lines snipped -- they ARE all present in sequence as expected...]
i shall eat 84 slices of pizza
i shall eat 85 slices of pizza
i shall eat 86 slices of pizza
```
