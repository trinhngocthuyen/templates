require "{{name}}/main"

Pod::HooksManager.register("{{name}}", :post_install) do |context|
  # Code goes here
end
