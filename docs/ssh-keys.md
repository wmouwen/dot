# SSH Keys

## Create a key

```shell
ssh-keygen -t ed25519 -C "username@hostname"
```

## Config

```
Host github.com
	User git

	IdentitiesOnly yes
	IdentityFile /path/to/.ssh/id_github

	VisualHostKey yes
	Compression yes
```
