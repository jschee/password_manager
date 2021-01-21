# password_manager
Command line app for managing your logins and generating random password string...

Using [thor](https://github.com/erikhuda/thor) and [yaml::store](https://ruby-doc.org/stdlib-2.7.2/libdoc/yaml/rdoc/YAML/Store.html) library(similar to PStore).

`ruby app.rb`

`
Commands:
  app.rb add DOMAIN USERNAME  # Add a new keychain...
  app.rb destroy              # Delete a keychain...
  app.rb help [COMMAND]       # Describe available commands or one specific command
  app.rb list DOMAIN          # List all keychains...
  app.rb update DOMAIN        # Update a keychain password...
`

`ruby app.rb add "somewebsite.com" "me@mail.com"`

`ruby app.rb list`

`"1 - somewebsite.com --- me@mail.com --- 506f1d24fe --- slug: 7604"`
