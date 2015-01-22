class SubnetsController < ApplicationController
  # GET /subnets
  # GET /subnets.xml
  def index
    @subnets = Subnet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subnets }
      format.json  { render :json => @subnets }
    end
  end

  # GET /subnets/1
  # GET /subnets/1.xml
  def show
    @subnet = Subnet.find(params[:id])

    @j = {}
    @j["attr"] = {}
    @j["attr"]["id"] = "node_" + @subnet.id.to_s
    @j["attr"]["network"] = @subnet.network
    @j["data"] = @subnet.network + " [" +  @subnet.description + "]"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subnet }
      format.json  { render :json => @j }
    end
  end
  
  # Fill in gap of missing subnet 
  def fillin
    subnet = Subnet.find(params[:id])
    status = ''
    
    @result = Array.new

    if subnet.children.length > 0
      list = subnet.children.collect {|c| c.network}
      new_list = subnet.cidr.fill_in(list, :Short => true)
  
      for net in new_list
        n = Subnet.find_or_create_by_network(net)
        n.move_to_child_of(subnet)
      end
    else
       status = '500'
       @result << 'No gaps to fill'

    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @result }
      format.json  { 
        if status.empty?
          render :json => @result 
        else
          render :json => @result, :status => status 
        end
      }
    end
  end

  # Find either the root or the children of given subnet
  def get_node
    root = false
    if params[:id].to_i ==  0
      root = true
      @subnets = Subnet.roots
    else 
      @subnets = Subnet.find(:all, :conditions => "parent_id = " + params[:id])
    end
    
    # Don't sort when querying on root node because there might be mixed of ipv4 and ipv6
    if ( root ) 
      sorted = @subnets.collect{|s| s.network}
    else
      begin
        # Get a sorted list which will be used later to return sorted subnets
        sorted = NetAddr.sort(@subnets.collect{|s| s.network})
      rescue
        sorted = @subnets.collect{|s| s.id.to_s + ' ' + s.network}
	raise "Unable to sort mixed IPv4 and IPv6 addresses: " + sorted.inspect
      end
    end

    @result = Array.new

    @subnets.sort_by{|s| sorted.index(s.network)}.each{|subnet|
      if ( subnet.root? or (params[:hide_empty] == 'true' and ((!subnet.description.nil? and subnet.description.length > 0) or (!subnet.children.nil? and subnet.children.length > 0) or !subnet.vlan_detail.nil?)) )
        @result << return_node(subnet)
      elsif (subnet.root? or (params[:show_only_empty] == 'true' and (subnet.description.nil? or subnet.description.length == 0) and subnet.vlan_detail.nil?) ) 
        @result << return_node(subnet)
      elsif (params[:hide_empty] == 'false' and params[:show_only_empty] == 'false')
        @result << return_node(subnet)
      end 
    }

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @result }
      format.json  { render :json => @result }
    end
  end

  def split
    @subnet = Subnet.find(params[:id])

    @result = Array.new
    status = ''
    # two types of split, by subnet or by host
    case params[:type]
    when 'subnet'
      cidr = @subnet.cidr
      netmask = cidr.bits()
      subnet_count = 2 ** (params[:input].to_i - netmask)
      # Fail when number of splitted subnet is too large
      if subnet_count < 257
        begin
          subnets = cidr.subnet(:Bits => params[:input].to_i, :Short => true)
          for sub in subnets
            n = Subnet.create!(:network => sub.to_s)
            n.move_to_child_of(@subnet)
          end
            @subnet.reload
        rescue Exception => exc
            # Set status to error so jQuery catches error
            status = '500'
            @result << exc.to_s
        end
      else
         status = '500'
         @result << "Size of splitted subnet is too big: " + subnet_count.to_s
      end
    when 'count'
      cidr = @subnet.cidr
      @result << cidr.size
      # Need to have some intelligence to detect large subnet split
      #cidr.subnet(:IPCount => params[:input].to_i, :Short => true).length
      #cidr.subnet(:IPCount => params[:input].to_i, :Short => true).each{|sub|
      #  @result << sub.to_s
      #}
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @result }
      format.json  { 
        if status.empty?
          render :json => @result 
        else
          render :json => @result, :status => status 
        end
      }
    end
  end

  # GET /subnets/new
  # GET /subnets/new.xml
  def new
    @subnet = Subnet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subnet }
    end
  end

  # GET /subnets/1/edit
  def edit
    @subnet = Subnet.find(params[:id])
  end

  # POST /subnets
  # POST /subnets.xml
  def create
    @subnet = Subnet.new(params[:subnet])

    respond_to do |format|
      if @subnet.save
        format.html { redirect_to(@subnet, :notice => 'Subnet was successfully created.') }
        format.xml  { render :xml => @subnet, :status => :created, :location => @subnet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subnet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subnets/1
  # PUT /subnets/1.xml
  def update
    @subnet = Subnet.find(params[:id])

    respond_to do |format|
      if @subnet.update_attributes(params[:subnet])
        format.html { redirect_to(@subnet, :notice => 'Subnet was successfully updated.') }
        format.xml  { head :ok }
        format.json  { render :json => @subnet }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subnet.errors, :status => :unprocessable_entity }
        format.json  { render :json => @subnet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subnets/1
  # DELETE /subnets/1.xml
  def destroy
    @subnet = Subnet.find(params[:id])
    @subnet.destroy

    respond_to do |format|
      format.html { redirect_to(subnets_url) }
      format.xml  { head :ok }
      format.json  { render :json => @subnet }
    end
  end
  
  # Assign network in the tree to vlan_detail 
  def assign_network
    @subnet = Subnet.find(params[:id])
    @vlan_detail = VlanDetail.find(params['vlan_detail_id'])

    # Variable holder for attribute update
    u = {}
    begin
      NetAddr.validate_ip_addr(@subnet.cidr.network, :Version => 6)
      u['subnet_v6'] = @subnet.network
    rescue NetAddr::ValidationError
      u['subnet'] = @subnet.network
    end

    respond_to do |format|
      if @vlan_detail.update_attributes(u)
        format.html { redirect_to(@vlan_detail, :notice => 'Subnet was successfully updated.') }
        format.xml  { head :ok }
        format.json  { render :json => @vlan_detail }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vlan_detail.errors, :status => :unprocessable_entity }
        format.json  { render :json => @vlan_detail.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # list_vlan
  def list_vlan
    status = ''
    @result = Array.new

    begin
      Colo.find(:all, :order => 'name').each{|colo|
        
        j = {}
        j[colo.name] = {}
        j[colo.name]['vlan_detail_id'] = Array.new
        j[colo.name]['vlan_detail_name'] = Array.new
        vds = VlanDetail.find(:all, :conditions => ["colo_id = ?", colo.id]).sort_by{|v| v.vlan.name}
        vds.each{|vd|
          j[colo.name]['vlan_detail_id'] << vd.id
          j[colo.name]['vlan_detail_name'] << vd.vlan.name
        }
        @result << j
      }
    rescue Exception => exc
      @result = Array.new
      status = '500'
      @result << "Error has occurred with vlan assignment: " + exc.to_s
      # Re-raise
      raise exc
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @result }
      format.json  { 
        if status.empty?
          render :json => @result 
        else
          render :json => @result, :status => status 
        end
      }
    end

  end


  # Search
  def search
    status = ''
    @result = Array.new

    # Search parameters
    options = {}
    options[:models] = [Subnet]
    options[:limit] = 1000

    # Escape colon because IPv6 uses it
    s = params[:search_string].gsub(/([:])/,"\\:")

    begin
      rs = Subnet.multi_solr_search("#{s}",options)

      rs.records.each{|s| 
        @result << s.self_and_ancestors.collect{|t| '#node_' + t.id.to_s}
      }

    rescue Exception => exc
      # Set status to error so jQuery catches error
      status = '500'
      @result << "Error has occurred with search: " + exc.to_s
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @result }
      format.json  { 
        if status.empty?
          render :json => @result 
        else
          render :json => @result, :status => status 
        end
      }
    end
  end

  private

  # Return single array with root to leaf
  def recursive_child(tree)
    subnet = tree[0]
    j = {}
    j["attr"] = {}
    j["attr"]["id"] = "node_" + subnet.id.to_s
    j["attr"]["network"] = subnet.network
    if subnet.description
      j["data"] = subnet.network + " - " +  subnet.description
    else 
      j["data"] = subnet.network
    end
    if !tree[1].nil?
      j["state"] = 'open'
      j["children"] = Array.new 
      tree.delete_at(0)
      j["children"] << recursive_child(tree)
    end
    j
  end

  def return_node(subnet)
    j = {}
    j["attr"] = {}
    j["attr"]["id"] = "node_" + subnet.id.to_s
    j["attr"]["network"] = subnet.network
    if !subnet.vlan_detail.nil? 
      j["data"] = subnet.network + ' (' + subnet.colo_name + ':' + subnet.vlan_name + ')'
    else
      j["data"] = subnet.network
    end
    if subnet.description
      j["data"] = j["data"] + " - " +  subnet.description
      j["attr"]["description"] = subnet.description
    end
    if subnet.children.length > 0
      j["state"] = 'closed'
    end
    j
  end
end
