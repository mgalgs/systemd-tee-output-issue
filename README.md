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
