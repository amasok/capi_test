#
# Cookbook Name:: app_user
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# 暗号化されたデータバッグの情報を取得
user = Chef::EncryptedDataBagItem.load("users", 'app2')
user_name = user['name']
password  = user['password']
ssh_key   = user['ssh_key']
home      = "/home/#{user_name}"

# 「app」ユーザの作成
user user_name do
  password password
  home  home
  shell "/bin/bash"
  supports :manage_home => true # ホームディレクトリも管理する
end

# 「app」をwheelグループに追加する
group "wheel" do
  action [:modify]
  members [user_name]
  append true
end

# .sshディレクトリを作ります
directory "#{home}/.ssh" do
  owner user_name
  group user_name
end

# authorized_keysファイルを作ります
authorized_keys_file ="#{home}/.ssh/authorized_keys"
file authorized_keys_file do
  owner user_name
  mode  0600
  content "#{ssh_key} #{user_name}" # ファイルの中身を直接指定
  not_if { ::File.exists?("#{authorized_keys_file}")} # 既にファイルが存在していたらリソースを実行しない
end
