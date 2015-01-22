# Copyright 2011 Google Inc. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class DnsZonesController < ApplicationController
  # GET /dns_zones
  # GET /dns_zones.xml
  def index
    @dns_zones = DnsZone.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dns_zones }
    end
  end

  # GET /dns_zones/1
  # GET /dns_zones/1.xml
  def show
    @dns_zone = DnsZone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dns_zone }
    end
  end

  # GET /dns_zones/new
  # GET /dns_zones/new.xml
  def new
    @dns_zone = DnsZone.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dns_zone }
    end
  end

  # GET /dns_zones/1/edit
  def edit
    @dns_zone = DnsZone.find(params[:id])
  end

  # POST /dns_zones
  # POST /dns_zones.xml
  def create
    @dns_zone = DnsZone.new(params[:dns_zone])

    respond_to do |format|
      if @dns_zone.save
        flash[:notice] = 'DnsZone was successfully created.'
        format.html { render :action => "edit" }
        #format.html { redirect_to(@dns_zone) }
        format.xml  { render :xml => @dns_zone, :status => :created, :location => @dns_zone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dns_zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dns_zones/1
  # PUT /dns_zones/1.xml
  def update
    @dns_zone = DnsZone.find(params[:id])

    respond_to do |format|
      if @dns_zone.update_attributes(params[:dns_zone])
        flash[:notice] = 'DnsZone was successfully updated.'
        format.html { render :action => "edit" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dns_zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dns_zones/1
  # DELETE /dns_zones/1.xml
  def destroy
    @dns_zone = DnsZone.find(params[:id])
    @dns_zone.destroy

    respond_to do |format|
      format.html { redirect_to(dns_zones_url) }
      format.xml  { head :ok }
    end
  end
  
  def create_ns_record
    @dns_zone = DnsZone.find(params[:id])

    @dns_zone.dns_ns_records << DnsNsRecord.create(params[:dns_ns_record])
    
    # Look up again to make sure we got it.
    @dns_zone = DnsZone.find(params[:id])
    render(:partial => "mini_ns_record",:object => @dns_zone) 

  end

  def destroy_ns_record
    dns_ns_record = DnsNsRecord.find(params[:id])
    @dns_zone = dns_ns_record.dns_zone
    
    dns_ns_record.destroy
    render(:partial => "mini_ns_record",:object => @dns_zone) 
  end

  def create_mx_record
    @dns_zone = DnsZone.find(params[:id])

    @dns_zone.dns_mx_records << DnsMxRecord.create(params[:dns_mx_record])
    
    # Look up again to make sure we got it.
    @dns_zone = DnsZone.find(params[:id])
    render(:partial => "mini_mx_record",:object => @dns_zone) 

  end

  # Delete MX record
  def destroy_mx_record
    dns_mx_record = DnsMxRecord.find(params[:id])
    @dns_zone = dns_mx_record.dns_zone
    
    dns_mx_record.destroy
    render(:partial => "mini_mx_record",:object => @dns_zone) 
  end

  # Build a zone file for a specified zone.  
  # Zone name must match what's defined in AST.
  def fetch_zone
    
    # zone name pass from url
    zone_name = params[:src]
    # Record type, A or PTR
    record_type = params[:type]
    # zone name pass from url
    network_type = params[:net]
    
    # Output Buffer
    @o = ''
    
    if network_type == 'int'
      dns_zone = DnsZone.find_by_name(zone_name + "-int")
    else
      dns_zone = DnsZone.find_by_name(zone_name)
    end
    
    # If can't find the specified zone, we'll return with some useful text
    if dns_zone.nil?
      @o += "; ##ERROR## Invalid zone name specified.\n"
      @o += "; Valid names can be one of the following:\n"
      
      @o += DnsZone.find(:all, :order => :name, :select => :name).collect{|a| "; " + a.name}.join("\n")
    else
      # Our rules for dns record generation.  
      # 1. Only generate a record once
      # 2. Generate record in closest zone defined.
      # 3. If nothing match, generate nothing.
      # 4. Record will be specified in absolute name, include the "." at the end
      # For ex: ads1.vip.sc9.yahoo.com should match zone, "vip.sc9.yahoo.com" first, if not found,
      # try sc9.yahoo.com, then yahoo.com, then .com.  If no zone match, then this record is ignored.
      # @o += "; Generated zone for #{zone_name} on #{Time.new.to_s}\n"
      # Dont think we need ORIGIN, will find out when deploy internal DNS
      #@o += "$ORIGIN #{dns_zone.name}.\n"
      @o += "$TTL #{dns_zone.my_ttl}\n"
      
      # In order to make sure we only generate one record, we actually have get all asset and zone
      # then put them in appropriate places.  It kinda suck, but one http call can't get us multiple file
      # Unless we get everything into one file, then have the local script to parse it into multiple
      # files, but that sounds a bit too hacky.  So instead, we let AST do the expensive work.

      # Alright, let's build the SOA first.
      @o += "@ \t IN \t SOA #{dns_zone.my_soa} (\n"
      @o += "\t\t\t #{Time.new.to_i} \t;serial\n"
      @o += "\t\t\t #{dns_zone.my_refresh} \t;refresh\n"
      @o += "\t\t\t #{dns_zone.my_retry} \t;retry\n"
      @o += "\t\t\t #{dns_zone.my_expire} \t;expire\n"
      @o += "\t\t\t #{dns_zone.my_minimum} \t;minimum\n"
      @o += ");\n"
      # NS
      for ns in dns_zone.my_dns_ns_records
        @o += "\t\tNS\t\t#{ns.name}.\n"        
      end
      # MX
      for mx in dns_zone.my_dns_mx_records
        @o += "\t\tMX\t\t#{mx.priority} #{mx.name}.\n"
      end
      
      @o += "\n"
      
      # use appropriate function for each type of record
      if record_type == 'a'
      	# If master A record is not null, put it in here
      	if ! dns_zone.mastera.nil?
          @o += "\t\t\t\t#{dns_zone.mastera}\n\n"
        end
        @o += fetch_dns_a(zone_name)  
      elsif record_type == 'ptr'
        @o += fetch_dns_ptr(zone_name)
      end
      #@o += assets.collect{|a| a.primary_interface.ip_to_string rescue nil}.join("<br/>")
    end
    
    render(:partial => "output",:object => @o) 

  end

  # Fetch ptr record
  # This is different from A record since we want to include not from hostname, but from IP address.
  # 1. we need to look at the zone_name to figure out the range of IP we need to include.
  # 2. find all the interfaces belong to that range, find its asset.
  # 3. for drac, we need add the hostname massage to add the "-d" to the hostname.
  # 4. Skip cname since they can't have PTR record.
  def fetch_dns_ptr(zone_name)
    
    @o = ''
    # find out the range we are parsing in this zone.
    ranges = []
    zone_name.split(".").map{|a| 
      # Make sure it's request for arpa zone which should be all number
      if ! (a =~ /^\d+$/).nil?
        if ranges.empty?
          ranges << a
        else
          ranges.insert(0, a)
        end
      end
    }
    
    # After look through zone name, if it's not a arpa zone, we'll return nil
    if ranges.empty?
      return @o
    end
    
    # Use later to determine how many number from ip we need
    zone_class = ranges.length
    
    # Now we have the range from zone name, let's use Networking class to help us find all interfaces
    # Find out wether it's class a, b, c or d
    netmask = 32 # start with D class netmask
    for i in (ranges.length..4-1)
      # Get the netmask correctly
      netmask = netmask - 8
      # Set the empty ip slot to 0
      ranges[i] = 0;
    end
    
    # Build the address
    range_address = ranges.join(".") + "/#{netmask}"
    
    # Call in cidr, find all interface under this range.
    interfaces = Networking.get_interfaces_in_range(range_address).sort{|a,b| a.ip <=> b.ip}

    # Find asset for each interface
    # If asset is Server, we need to look up two things
    # 1. If ip is drac, we will add "-d" to the hostname
    # 2. Maybe for vip, we need to ptr to it, but on the second thought, that shouldn't be.    
    for interface in interfaces

      # Build the ip correct for this zone
      ips = []
      ip_parts = interface.ip_to_string.split(".")
      for i in (zone_class..4-1)
        # Insert reversely
        ips.insert(0, ip_parts[i])
      end
      ip = ips.join(".")
      
      # If it's a drac and type = server, we transform the hostname
      if ( interface.drac_ip?  && interface.asset.resource_type == 'Server')
        name = convert_to_drac_name(interface.asset.name)
      else
        # Check to see if there is multiple vips poing to this ip, if so raise exception.
        # If only one ip, then we'll point PTR record to that vip.
        if interface.vips.length > 1
          #raise "#{interface.ip_to_string} has more than one vip " + interface.vips.collect{|a| a.name}.inspect + " pointing to it"
          @o += ";#{interface.ip_to_string} has more than one vip " + interface.vips.collect{|a| a.name}.inspect + " pointing to it.\n"
          @o += ";Picking the first one.\n"
          name = interface.vips[0].name          
        elsif interface.vips.length == 1
          name = interface.vips[0].name
        # Network asset with named interface
        elsif interface.asset.resource_type == 'Network' and interface.name and interface != interface.asset.primary_interface and ! interface.name.empty?
          name = interface.name + '.' + interface.asset.name
        else
          name = interface.asset.name  
        end
        
      end
      
      @o += "#{ip}\t\tPTR\t\t#{name}.\n"

    end

    return @o

    rescue Exception => exc
       flash[:interface] = "##ERROR## Fetch failed following reason: #{exc.message}\n"

          
  end

  # Fetch A records
  def fetch_dns_a(zone_name)

    @o = ''
    
    # Initialize all zone in hash first
    all_dns_zones = {}
    for zone in DnsZone.find(:all)
      all_dns_zones[zone.name] = []
    end
        
    # Here comes the expensive part.  Look through each asset
    for asset in Asset.find(:all, :order => "assets.name", :include => :interfaces)
      # Split up the name so we can look for domains
      name_parts = asset.name.split(".")
      # Start looking for closest match with dns_zone 
      for i in (1..name_parts.length - 1)
        test_zone = ''
        (i..name_parts.length - 1).each {|j| test_zone += name_parts[j] + "."}
        test_zone = test_zone.chop

        # Try to see if it match names in zone starting with closest match
        if ! all_dns_zones[test_zone].nil?
          all_dns_zones[test_zone] << asset
          break
        end
      end
    end

    
#    @o += "; Total of #{all_dns_zones[zone_name].length} assets\n\n"

    # Now we have each asset throw into the bucket of each zone file. 
    # It's time to build the config for the requested zone
    for asset in all_dns_zones[zone_name]
      if ( asset.resource_type != 'DnsCname' )
        if ! asset.primary_interface.nil? 
          @o += "#{asset.name}. \t\tA\t\t #{asset.primary_interface.ip_to_string}\n"
        else
          # drac address is ok for non-server type asset, so we'll test for that here.
          if asset.resource_type != 'Server' and ! asset.primary_interface_including_drac.nil?
            @o += "#{asset.name}. \t\tA\t\t #{asset.primary_interface_including_drac.ip_to_string}\n"
          else
            @o += "; #{asset.name} DOESN'T have IP assigned.\n"  
          end
        end

        # For network equipment, they have multiple interfaces
        # and if interface has name assigned to it, it should create record for that
        if asset.resource_type == 'Network' and asset.non_primary_interfaces.length > 0
          begin
            asset.non_primary_interfaces.sort_by{|a| (a && a.send(:name)) || ""}.each{|i|
              # If name wasn't nil and not empty
              if !i.name.nil? and ! i.name.empty?
                @o += "#{i.name}.#{asset.name}. \t\tA\t\t #{i.ip_to_string}\n"
              end
            }
          rescue Exception => e
            @o += "; #INVALID# #{asset.name}: " + e + "\n"
          end
        end

        
        # If drac exist for server, we will add them here
        # Need to add "-d" to the host name
        if ! asset.drac_interface.nil? and asset.resource_type == "Server"
          drac_name = convert_to_drac_name(asset.name)
          @o += "#{drac_name}. \t\tA\t\t #{asset.drac_interface.ip_to_string}\n"
        end
      # If record is of type "DnsCname", it could have multiple A record
      # So we treat them with some special care.
      else
        # Check if cname is pointing to external
        if ! asset.resource.external.nil? and ! asset.resource.external.empty?
          @o += "#{asset.name}. \t\tCNAME\t\t #{asset.resource.external}.\n"
        # Check if cname is pointing to any host
        elsif asset.resource.cname_assets.length > 0 
          for cname_detail_asset in asset.resource.cname_assets
            if ! cname_detail_asset.primary_interface.nil? 
              @o += "#{asset.name}. \t\tA\t\t #{cname_detail_asset.primary_interface.ip_to_string}\n"
            end
          end
        else
          @o += "; #{asset.name} DOESN'T have IP assigned.\n"
        end
      end
    end    
    
    return @o
    
    rescue Exception => exc
      flash[:interface] = "##ERROR## Fetch failed with following reason: #{exc.message}\n#{exc.backtrace}"
  end

  def convert_to_drac_name(name)
              
    name_parts = name.split(".")
    name_parts[0] = name_parts[0] + "-d"
    if name_parts[name_parts.length - 1] =~ /com/
      name_parts[name_parts.length - 1] = 'int'
    end
    drac_name = name_parts.join(".")

  end

end
