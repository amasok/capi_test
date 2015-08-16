local_mode true

chef_repo_dir = File.absolute_path( File.dirname(__FILE__) + "/.." )
cookbook_path ["#{chef_repo_dir}/cookbooks"]
node_path     "#{chef_repo_dir}/nodes"
role_path     "#{chef_repo_dir}/roles"
ssl_verify_mode  :verify_peer
encrypted_data_bag_secret "./data_bag_key"
