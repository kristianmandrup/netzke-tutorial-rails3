require 'netzke_data'

# Initial tree data
root = Folder.create(:name => '/')
root.children.create(:name => 'One')
root.children.create(:name => 'Two').children.create(:name => 'Three')

Netzke::Data.regenerate_test_data
# Netzke::Data.reset_configs

user_role = Role.create(:name => 'user')
