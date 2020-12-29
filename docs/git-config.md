# Git Config

## User credentials

```shell
git config user.name "Your Name"
git config user.email "username@domain.tld"
```

## Signed commits

Select a private key identifier from the available [GPG keys](gpg-keys.md#list-keys).

```shell
git config user.signingkey 3AA5C34371567BD2
```

Use the `-S` flag to sign a commit.

```shell
# Specify GPG key during commit:
git commit --gpg-sign=3AA5C34371567BD2
git commit -S 3AA5C34371567BD2

# Use GPG key from Git configuration:
git commit --gpg-sign
git commit -S
```

Alternatively, sign all commits for the repository using the git configuration.

```shell
git config commit.gpgsign true
```

## Signed tags

Sign a tag using the git configuration GPG key:

```shell
git tag --sign v1.3.0
```
