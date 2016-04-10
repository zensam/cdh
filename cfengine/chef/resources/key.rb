
actions :add, :remove
default_action :add

attribute :key, :kind_of => String, :name_attribute => true
attribute :url, :kind_of => String, :default => nil