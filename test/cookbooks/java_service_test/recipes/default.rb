include_recipe 'java-service'

template '/root/EchoServer.java' do
  source 'EchoServer.java.erb'
end

execute 'javac EchoServer.java' do
  cwd '/root'
end

file '/root/manifest.txt' do
  content "Main-Class: EchoServer\n"
end

execute 'jar cvfm server.jar manifest.txt EchoServer.class' do
  cwd '/root'
end

java_service 'echoserver' do
  action [:create, :enable, :load, :start]
  main_class 'EchoServer'
  classpath '/root/server.jar'
  user 'root'
  pill_file_dir '/root'
  log_file '/root/theoutput.log'
end

java_service 'echoserver2' do
  action [:create, :enable, :load, :start]
  jar '/root/server.jar'
  user 'root'
  working_dir '/root'
  classpath Proc.new{ "late:bound:string" }
end

java_service 'nooptionsorargs' do
  action [:create, :enable, :load, :start]
  jar '/root/server.jar'
  user 'root'
end

# java_service 'echoserver' do
#   action :restart
# end

# java_service 'echoserver' do
#   action :stop
# end

# java_service 'echoserver' do
#   action :start
# end
