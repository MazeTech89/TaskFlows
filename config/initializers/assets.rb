# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap/dist/js")
Rails.application.config.assets.precompile << "bootstrap.bundle.min.js"

# Development/Windows fix: avoid writing Sprockets cache files under tmp/cache/assets
# when the project directory has restricted permissions.
#
# Rails 8 defaults to Propshaft; in that case `Rails.application.assets` is a
# Propshaft::Assembly and does not support `cache=`. Only apply this when the
# Sprockets environment is actually in use.
if Rails.env.development? && defined?(Sprockets)
	assets_env = (Rails.application.assets if Rails.application.respond_to?(:assets))
	if assets_env && assets_env.respond_to?(:cache=)
		assets_env.cache = Sprockets::Cache::MemoryStore.new
	end
end
