if File.exist? '/opt/hbase'

  return_value = { 'installed' => true, 'version' => File.readlink('/opt/hbase').split('-')[-1] }

  return_value['rsa_2048_keys'] = {}
  users = [ 'hbase' ]
  users.each do |user|
    if File.exist? "/home/#{user}/.ssh/id_rsa.pub"
      return_value['rsa_2048_keys'][user] = File.open("/home/#{user}/.ssh/id_rsa.pub", 'r') { |f| f.read }
    end
  end

  if File.exist? '/etc/hbase/conf/.cluster'
    return_value['cluster'] = File.open('/etc/hbase/conf/.cluster', 'r') { |f| f.read }
  end

  return_value['roles'] = {}
  roles = ['master','regionserver']
  roles.each do |role|
    if File.exist? "/etc/hbase/conf/.#{role}"
      return_value['roles'][role] = true
    else
      return_value['roles'][role] = false
    end
  end

  Facter.add(:hbase) do
    setcode do
      return_value
    end
  end

else
  Facter.add(:hbase) do
    setcode do
      { 'installed' => false }
    end
  end
end
