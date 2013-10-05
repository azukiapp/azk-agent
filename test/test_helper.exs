Dynamo.under_test(AzkAgent.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule AzkAgent.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
