# eefest19demo
Demonstration on Erlang &amp; Elixir Fest 2019

## Agenda / Branches

1. Provisioning of `hello_nerves` project and Building it
1. Burning firm to microSD, Booting and Running IEx
1. Editing `lib/hello_nerves.ex` and Burning by `ssh nerves.local`
1. Burning firm over NervesHub
1. Running device controlling apps integrated with scenic

## Instruction

### 1. Provisioning and Building

#### Create the project

```
$ mix nerves.new hello_nerves --init-gadget
$ cd hello_nerves
```

#### Setup ssh connection to nerves.local

```
$ ssh-keygen -t rsa -P "" -C  "eefest19" -f eefest19
Generating public/private rsa key pair.
Your identification has been saved in eefest19.
Your public key has been saved in eefest19.pub.
The key fingerprint is:
SHA256:dz+vWXjW7LqFFgNCybphcHPyi7SkQItkEGMZfMDEhvY eefest19
The key's randomart image is:
+---[RSA 2048]----+
|XB+      ...     |
|oOo.. . +.+      |
|oooo . o *. .    |
|  .Eo   * .. .   |
|     . =S=... o  |
|      . +... . *.|
|              * B|
|             . X |
|              =+o|
+----[SHA256]-----+

$ mv eefest* ~/.ssh/
$ vim ~/.ssh/config
# Add following block
Host nerves.local
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  IdentityFile ~/.ssh/eefest19

$ vim config/config.exs
# Edit as follow
$ git diff config/config.exs
diff --git a/hello_nerves/config/config.exs b/hello_nerves/config/config.exs
index da0c2ac..b5335a6 100644
--- a/hello_nerves/config/config.exs
+++ b/hello_nerves/config/config.exs
@@ -45,7 +45,10 @@ if keys == [],
     """)
 
 config :nerves_firmware_ssh,
-  authorized_keys: Enum.map(keys, &File.read!/1)
+  authorized_keys: [
+    "Paste contents of ~/.ssh/eefest19.pub here"
+  ]
 
 # Configure nerves_init_gadget.
 # See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.

```

#### Build the project

```
$ export MIX_TARGET=rpi0
$ mix deps.get
$ mix firmware
```

#### Burn the firmware

Connect microSD to hostPC, then,,,

```
$ mix firmware.burn
```
