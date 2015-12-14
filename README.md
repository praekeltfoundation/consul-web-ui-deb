# consul-web-ui-deb
Files for packaging the [Consul](https://consul.io) open source web UI as a .deb file.

Builds a .deb package using Praekelt's packaging and deployment tool, [Sideloader](https://github.com/praekelt/sideloader).

Signatures for the Consul web UI are verified using Hashicorp's PGP public key. The key is available [here](https://hashicorp.com/security.html) and needs to be added to the build user's default keyring for builds to complete.

The build package will include:
* The open source Consul web UI static files

#### Some notes:
* The package name is `consul-web`.
* The Consul web UI static files are installed to `/usr/share/consul-web`.
* This package depends on the [`consul` package](https://github.com/praekeltfoundation/consul-deb).
* **It is up to the user to configure Consul to actually use the installed web UI, i.e. set `-ui-dir=/usr/share/consul-web`**
