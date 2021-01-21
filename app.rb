require "thor"
require "yaml/store"
require "securerandom"
require_relative "./keychain.rb"

class KeyChainManager < Thor

  desc "add DOMAIN USERNAME", "Add a new keychain..."

  def add(domain, username)
    password = generate_password
    slug = generate_slug
    new_ps.transaction do |x|
      x[:keychains] ||= Array.new
      x[:keychains].push(Keychain.new(url:"#{domain}", username:"#{username}", password:"#{password}", slug: "#{slug}"))
    end
    puts "Generated your password: #{password}"
  end

  desc "update DOMAIN", "Update a keychain password..."

  def update
    load_and_list
    p "Type the slug of item to update a keychain password..."
    input = STDIN.gets.chomp
    select_and_update(input)
  end

  desc "destroy", "Delete a keychain..."

  def destroy
    load_and_list
    p "Type the slug of item to delete keychain..."
    input = STDIN.gets.chomp
    select_and_destroy(input)
  end

  desc "list DOMAIN", "List all keychains..."

  def list
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
         p "#{i+1} - #{item.url} --- #{item.username} --- #{item.password} --- slug: #{item.slug}"
        end
      end
    end
  end

  def select_and_update(input)
    new_ps.transaction do |store|
      store.roots.each do |x|
        obj = store[x].select{|keychain| keychain.slug == input.to_s}
        obj.first.password = generate_password
        p "The password for this keychain has been updated to #{obj.first.password}"
      end
    end
  end

  def select_and_destroy(input)
    new_ps.transaction do |store|
      store.roots.each do |x|
       store[x].delete_if{|keychain| keychain.slug == input.to_s}
       p "Keychain has been deleted"
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
