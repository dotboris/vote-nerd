defmodule VoteNerd.RegistryTest do
  use ExUnit.Case

  alias VoteNerd.{Registry, PrivateChat}

  setup do
    {:ok, chat_supervisor} = PrivateChat.Supervisor.start_link(nil)
    {:ok, registry} = Registry.start_link(chat_supervisor, nil)
    {:ok, registry: registry, chat_supervisor: chat_supervisor}
  end

  test "returns same pid for same id", %{registry: registry} do
    pid1 = Registry.chat(registry, 42)
    pid2 = Registry.chat(registry, 42)

    assert pid1 == pid2
  end

  test "returned pid is alive and well", %{registry: registry} do
    pid = Registry.chat(registry, 9001)

    assert Process.alive?(pid)
  end

  test "returns different pid if existing child dies", %{registry: registry} do
    pid1 = Registry.chat(registry, 9001)

    ref = Process.monitor(pid1)
    Process.exit(pid1, :kill)
    assert_receive {:DOWN, ^ref, _, _, _}

    pid2 = Registry.chat(registry, 9001)

    assert pid1 != pid2
  end

  test "returns different pid for different id", %{registry: registry} do
    pid1 = Registry.chat(registry, 421)
    pid2 = Registry.chat(registry, 422)

    assert pid1 != pid2
  end
end
