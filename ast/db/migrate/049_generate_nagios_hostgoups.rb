class GenerateNagiosHostgoups < ActiveRecord::Migration
  def self.up
    
    hostgroups = ['ads','cpm','mq','oc','web','db-master',
    'db-slave','ac','tic','feed','tap','me','mm','r','uu',
    'www','df','dmdb','dm','mid','tool','tool1','tool2',
    'had','log','log101','log104','dev1']
    
    for hostgroup in hostgroups
      v = NagiosHostGroup.find_or_create_by_name(hostgroup)
      v.save!
    end
    

  end

  def self.down
  end
end
