# frozen_string_literal: true

# Check that the app is configured correctly. Raise some helpful errors if something is wrong.

if defined?(Rails::Server) && Rails.env.production? # Only run these checks when starting up a production server
  puts "Checking config..."
  if %w[localhost production.localhost].include?(Discourse.current_hostname)
    puts <<~TEXT

      Discourse.current_hostname = '#{Discourse.current_hostname}'

      Please update the host_names property in config/database.yml
      so that it uses the hostname of your site. Otherwise you will
      experience problems, like links in emails using #{Discourse.current_hostname}.

    TEXT

    raise "Invalid host_names in database.yml"
  end

  if !Dir.glob(File.join(Rails.root, "public", "assets", "application*.js")).present?
    puts <<~TEXT

      Assets have not been precompiled. Please run the following command
      before starting the rails server in production mode:

          rake assets:precompile

    TEXT

    raise "Assets have not been precompiled"
  end
end
