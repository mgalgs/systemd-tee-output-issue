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
Oct 26 12:13:53 grinchel systemd[2702]: Started Test teeing under systemd.
░░ Subject: A start job for unit UNIT has finished successfully
░░ Defined-By: systemd
░░ Support: https://forum.manjaro.org/c/support
░░
░░ A start job for unit UNIT has finished successfully.
░░
░░ The job identifier is 713.
Oct 26 12:13:54 grinchel tee_test.sh[117352]: i shall eat 2 slices of pie
Oct 26 12:13:55 grinchel tee_test.sh[117352]: i shall eat 3 slices of pie
Oct 26 12:13:56 grinchel tee_test.sh[117352]: i shall eat 4 slices of pie
Oct 26 12:13:57 grinchel tee_test.sh[117352]: i shall eat 5 slices of pie
Oct 26 12:13:58 grinchel tee_test.sh[117352]: i shall eat 6 slices of pie
Oct 26 12:13:59 grinchel tee_test.sh[117352]: i shall eat 7 slices of pie
Oct 26 12:14:00 grinchel tee_test.sh[117352]: i shall eat 8 slices of pie
Oct 26 12:14:01 grinchel tee_test.sh[117352]: i shall eat 9 slices of pie
Oct 26 12:14:02 grinchel tee_test.sh[117352]: i shall eat 10 slices of pie
Oct 26 12:14:03 grinchel tee_test.sh[117352]: i shall eat 11 slices of pie
Oct 26 12:14:04 grinchel tee_test.sh[117352]: i shall eat 12 slices of pie
Oct 26 12:14:05 grinchel tee_test.sh[117352]: i shall eat 13 slices of pie
Oct 26 12:14:06 grinchel tee_test.sh[117352]: i shall eat 14 slices of pie
Oct 26 12:14:07 grinchel tee_test.sh[117352]: i shall eat 15 slices of pie
Oct 26 12:14:08 grinchel tee_test.sh[118097]: i shall eat 16 slices of pizza
Oct 26 12:14:08 grinchel tee_test.sh[117352]: i shall eat 16 slices of pie
Oct 26 12:14:09 grinchel tee_test.sh[117352]: i shall eat 17 slices of pie
Oct 26 12:14:10 grinchel tee_test.sh[117352]: i shall eat 18 slices of pie
Oct 26 12:14:11 grinchel tee_test.sh[117352]: i shall eat 19 slices of pie
Oct 26 12:14:12 grinchel tee_test.sh[118350]: i shall eat 20 slices of pizza
Oct 26 12:14:12 grinchel tee_test.sh[117352]: i shall eat 20 slices of pie
Oct 26 12:14:13 grinchel tee_test.sh[117352]: i shall eat 21 slices of pie
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
i shall eat 8 slices of pizza
i shall eat 9 slices of pizza
i shall eat 10 slices of pizza
i shall eat 11 slices of pizza
i shall eat 12 slices of pizza
i shall eat 13 slices of pizza
i shall eat 14 slices of pizza
i shall eat 15 slices of pizza
i shall eat 16 slices of pizza
i shall eat 17 slices of pizza
i shall eat 18 slices of pizza
i shall eat 19 slices of pizza
i shall eat 20 slices of pizza
i shall eat 21 slices of pizza
```
