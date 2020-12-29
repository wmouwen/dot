# GPG Keys

## Create a key

```shell
gpg --full-generate-key
```

Select 'RSA and RSA' with 4096 bits.

## List keys

```shell
gpg --list-secret-keys --keyid-format LONG

# Example output part:
~/.gnupg/secring.gpg
------------------------------------
sec   rsa4096/3AA5C34371567BD2 2016-03-10 [expires: 2017-03-10]
      42B317FD4BA89E7A42B317FD4BA89E7A42B317
uid                          username 
ssb   rsa4096/42B317FD4BA89E7A 2016-03-10
```

The long hexadecimal code behind 'sec rsa/4096' is the private key identifier.

## Export armored key

Useful for, for example, GitHub

```shell
gpg --armor --export 3AA5C34371567BD2
```
