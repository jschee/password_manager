require "thor"
require "yaml/store"
require "securerandom"
require_relative "./keychain.rb"

class KeyChainManager < Thor

  desc "add_keychain DOMAIN USERNAME", "Add a new keychain"

  def add_keychain(domain, username)
    password = generate_password
    slug = generate_slug
    new_ps.transaction do |x|
      x[:keychains] ||= Array.new
      x[:keychains].push(Keychain.new(url:"#{domain}", username:"#{username}", password:"#{password}", slug: "#{slug}"))
    end
  end

  desc "destroy_keychain", "Delete a keychain by typing the slug"

  def destroy_keychain
    load_and_list

    p "Type the slug of item to delete keychain..."
    input = STDIN.gets.chomp

    new_ps.transaction do |store|
      store.roots.each do |x|
       store[x].delete_if{|keychain| keychain.slug == input.to_s}
       p "Keychain has been deleted"
      end
    end
  end

  desc "update_keychain DOMAIN", "select a keychain"

  def update_keychain
    load_and_list
    p "Type the slug of item to update a keychain password..."
    input = STDIN.gets.chomp
    new_ps.transaction do |store|
      store.roots.each do |x|
        obj = store[x].select{|keychain| keychain.slug == input.to_s}
        obj.first.password = generate_password
        p "The password has been updated to #{obj.first.password}"
      end
    end
  end

  desc "list_keychain DOMAIN", "List all keychains"

  def list_keychain
    indexed_objects
  end

  private

  def load_and_list
    YAML.load_file('db/db.yml')
    indexed_objects
  end

  def indexed_objects
    new_ps.transaction do |store|
      store.roots.each do |x|
        store[x].each_with_index do |item, i|
         puts "#{i+1} - #{item.url} --- #{item.username} --- #{item.password} --- slug: #{item.slug}"
        end
      end
    end
  end

  def generate_password
    SecureRandom.hex(5)
  end

  def generate_slug
    SecureRandom.hex(2)
  end

  def new_ps
    YAML::Store.new("db/db.yml")
  end

end


KeyChainManager.start(ARGV)
