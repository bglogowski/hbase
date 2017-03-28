if File.exist? '/opt/hbase'

  return_value = { 'installed' => true, 'version' => File.readlink('/opt/hbase').split('-')[-1] }

  if File.exist? '/home/hbase/.ssh/id_rsa.pub'
    return_value['rsa_2048_key'] = File.open('/home/hbase/.ssh/id_rsa.pub', 'r') { |f| f.read }
  end

  return_value['phoenix'] = { 'installed' => false }

  if File.exist? '/etc/hbase/conf/.cluster'
    return_value['cluster'] = File.open('/etc/hbase/conf/.cluster', 'r') { |f| f.read }
  end

  if File.exist? '/etc/hbase/conf/.role'
    return_value['role'] = File.open('/etc/hbase/conf/.role', 'r') { |f| f.read }
  end
  
  if File.exist? '/opt/phoenix'
    phoenix_version = File.readlink('/opt/phoenix').split('-')[2]
    hbase_mm = return_value['version'].split('.')[0..1].join('.')
    
    if File.readlink('/opt/phoenix').split('-')[-2] == hbase_mm
      return_value['phoenix'] = { 'installed' => true, 'version' => phoenix_version } 
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
