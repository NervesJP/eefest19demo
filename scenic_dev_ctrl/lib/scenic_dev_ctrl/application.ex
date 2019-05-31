defmodule ScenicDevCtrl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  use GenServer
  require Logger

  alias Circuits.GPIO

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ScenicDevCtrl.Supervisor]
    Supervisor.start_link(children(@target), opts)
    GenServer.start_link(__MODULE__, [])
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Starts a worker by calling: ScenicDevCtrl.Worker.start_link(arg)
      # {ScenicDevCtrl.Worker, arg},
    ]
  end

  def children(_target) do
    {:ok, engine} = NervesKey.PKCS11.load_engine()
    {:ok, i2c} = ATECC508A.Transport.I2C.init([])

    cert =
      NervesKey.device_cert(i2c, :aux)
      |> X509.Certificate.to_der()

    signer_cert =
      NervesKey.signer_cert(i2c, :aux)
      |> X509.Certificate.to_der()

    key = NervesKey.PKCS11.private_key(engine, i2c: 1)
    cacerts = [signer_cert | NervesHub.Certificate.ca_certs()]

    [
      {NervesHub.Supervisor, [key: key, cert: cert, cacerts: cacerts]}
    ]
  end

  def init(_) do
    {:ok, button} = GPIO.open(5, :input, pull_mode: :pullup)
    GPIO.set_interrupts(button, :both)
    {:ok, i2c} = Circuits.I2C.open("i2c-1")
    {:ok, %{button: button, i2c: i2c}}
  end

  def handle_info({:circuits_gpio, 5, _timestamp, value}, state) do
    Logger.debug("Button is now #{value}")
    Circuits.I2C.write(state.i2c, 60, <<0x00, 0xa7 - value>>)
    {:noreply, state}
  end
  
end
