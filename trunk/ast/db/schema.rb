# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090512212144) do

  create_table "assets", :force => true do |t|
    t.string   "name"
    t.integer  "colo_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rack"
    t.integer  "state_id"
    t.text     "note"
    t.string   "asset_tag"
    t.string   "row"
    t.integer  "pos"
    t.text     "ocs_history"
  end

  add_index "assets", ["name"], :name => "index_assets_on_name"

  create_table "ast_bases", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "auditable_parent_id"
    t.string   "auditable_parent_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",               :default => 0
    t.datetime "created_at"
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["auditable_parent_id", "auditable_parent_type"], :name => "auditable_parent_index"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"

  create_table "colos", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cpu_details", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "cpu_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_cores"
  end

  create_table "cpu_models", :force => true do |t|
    t.string   "ctype"
    t.string   "speed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disk_details", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "disk_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cnt",           :default => 1
    t.string   "scsiid"
  end

  create_table "disk_models", :force => true do |t|
    t.string   "name"
    t.string   "speed"
    t.integer  "capacity"
    t.string   "part_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "drivetype"
  end

  create_table "dns_cname_details", :force => true do |t|
    t.integer  "dns_cname_id"
    t.integer  "asset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dns_cnames", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dns_mx_records", :force => true do |t|
    t.string   "name"
    t.integer  "dns_zone_id"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dns_ns_records", :force => true do |t|
    t.string   "name"
    t.integer  "dns_zone_id"
    t.integer  "ttl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dns_zones", :force => true do |t|
    t.string   "name"
    t.string   "soa"
    t.string   "a"
    t.integer  "inherit"
    t.integer  "ttl"
    t.integer  "refresh"
    t.integer  "retry"
    t.integer  "expire"
    t.integer  "minimum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interfaces", :force => true do |t|
    t.string   "name"
    t.boolean  "real_ip"
    t.text     "description"
    t.integer  "ip",             :limit => 8
    t.integer  "asset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mac"
    t.integer  "vlan_detail_id"
  end

  create_table "memory_details", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "memory_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "slot"
  end

  create_table "memory_models", :force => true do |t|
    t.string   "speed"
    t.string   "mtype"
    t.integer  "capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nagios_contact_group_service_escalation_details", :force => true do |t|
    t.integer  "nagios_contact_group_id"
    t.integer  "nagios_service_escalation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nagios_contact_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nagios_host_groups", :force => true do |t|
    t.string   "name"
    t.text     "hosts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nagios_host_template_id"
  end

  create_table "nagios_host_templates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nagios_service_details", :force => true do |t|
    t.integer  "nagios_host_group_id"
    t.integer  "nagios_service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nagios_service_escalation_templates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nagios_service_escalations", :force => true do |t|
    t.integer  "nagios_service_detail_id"
    t.integer  "nagios_service_escalation_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nagios_service_group_details", :force => true do |t|
    t.integer  "nagios_service_group_id"
    t.integer  "nagios_host_group_id"
    t.integer  "nagios_service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nagios_service_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nagios_service_templates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nagios_services", :force => true do |t|
    t.string   "name"
    t.integer  "nagios_service_template_id"
    t.string   "check_command"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "network_models", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit"
  end

  create_table "networks", :force => true do |t|
    t.integer  "network_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pdu_models", :force => true do |t|
    t.string   "part_number"
    t.string   "manufacture"
    t.integer  "receptible"
    t.string   "voltage"
    t.string   "ampere"
    t.string   "wattage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit"
    t.string   "oid_load"
    t.string   "snmp_read"
  end

  create_table "pdus", :force => true do |t|
    t.integer  "consumption"
    t.integer  "pdu_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "server_models", :force => true do |t|
    t.string   "manufacture"
    t.string   "model"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit"
  end

  create_table "servers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "server_model_id"
    t.string   "service_tag"
    t.string   "bios_version"
  end

  create_table "service_check_details", :force => true do |t|
    t.integer  "service_container_id"
    t.integer  "service_check_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_checkers", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "checker_type"
    t.integer  "strict"
    t.string   "definition",   :limit => 2048
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "home"
    t.text     "command"
    t.text     "label"
  end

  create_table "service_checks", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "parent_id"
    t.integer  "service_checker_id"
    t.string   "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "autofix"
    t.text     "command"
    t.integer  "frequency"
    t.text     "root"
  end

  create_table "service_container_details", :force => true do |t|
    t.integer  "nagios_host_group_id"
    t.integer  "service_container_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_containers", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "frequency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "autofix"
    t.text     "check_command"
    t.text     "nagios_service_template_id"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "storages", :force => true do |t|
    t.string   "raid_type"
    t.string   "controller"
    t.string   "enclosure"
    t.string   "os"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit"
  end

  create_table "vip_servers", :force => true do |t|
    t.integer  "vip_asset_id"
    t.integer  "asset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "port"
  end

  create_table "vips", :force => true do |t|
    t.integer  "hoster_id"
    t.integer  "port"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "proto"
    t.string   "flag"
    t.integer  "interface_id"
  end

  create_table "vlan_details", :force => true do |t|
    t.integer  "colo_id"
    t.integer  "vlan_id"
    t.string   "subnet"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vlans", :force => true do |t|
    t.string   "name"
    t.integer  "vlan_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "drac",        :default => false
  end

end
