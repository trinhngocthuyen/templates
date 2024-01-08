require "cocoapods-{{name}}/main"

Pod::HooksManager.register("cocoapods-{{name}}", :post_install) do |context|
  # Code goes here
end
