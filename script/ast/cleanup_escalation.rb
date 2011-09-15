escalations = NagiosServiceEscalation.find(:all)

# Find escalation without proper service_detail
escalations.each { |a| 
  if ! a.nagios_service_detail
    puts "Destroying escalation #{a.id}"
    a.destroy
  end  

}

puts "Finding nil nagios_host_group"
# Find again
escalations = NagiosServiceEscalation.find(:all)

escalations.each { |a| 
  # Find escalation with good service detail but bad hostgroup
  if ! a.nagios_service_detail.nagios_host_group 
    puts "Destroying escalation #{a.id} with no nagios_host_group"
    a.destroy
  end  
}

puts "Finding nil nagios_service"
escalations = NagiosServiceEscalation.find(:all)

escalations.each { |a| 
  # Find escalation with good service detail but bad hostgroup
  if ! a.nagios_service_detail.nagios_service
    puts "Destroying escalation #{a.id} with no nagios_service"
    a.destroy
  end  
}

