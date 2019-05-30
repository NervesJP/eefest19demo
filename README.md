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

Connect microSD to hostPC with SD writer, and then,,,

```
$ mix firmware.burn
```

#### Connect the Nerves by ssh on VirtualEther

```
$ ssh nerves.local 
Warning: Permanently added 'nerves.local,172.31.125.113' (RSA) to the list of known hosts.
Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
Toolshed imported. Run h(Toolshed) for more info
RingLogger is collecting log messages from Elixir and Linux. To see the
messages, either attach the current IEx session to the logger:

  RingLogger.attach

or print the next messages in the log:

  RingLogger.next

iex(hello_nerves@nerves.local)1> uname 
Nerves nerves-2131 hello_nerves 0.1.0 (bee968a4-58e8-5d2e-6dd1-954970a1529c) arm
iex(hello_nerves@nerves.local)2> HelloNerves.hello
:world
```

Enjoy the Nerves Hello World and IEx!!
