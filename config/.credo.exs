%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/"],
        excluded: []
      },
      checks: [
        # We don't really care about module docs at this point in the codebase.
        # We're still playing around.
        {Credo.Check.Readability.ModuleDoc, false}
      ]
    }
  ]
}
