release :example_app do
  set version: current_version(:example_app)
  set applications: [
    :runtime_tools
  ]
  set commands: [
    migrate: "rel/commands/migrate.sh"
  ]
end
