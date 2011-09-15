CREATE TABLE `assets` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `colo_id` int(11) default NULL,
  `resource_id` int(11) default NULL,
  `resource_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `rack` varchar(255) default NULL,
  `state_id` int(11) default NULL,
  `note` text,
  PRIMARY KEY  (`id`),
  KEY `index_assets_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;

CREATE TABLE `colos` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `disk_details` (
  `id` int(11) NOT NULL auto_increment,
  `asset_id` int(11) default NULL,
  `disk_model_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `cnt` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `disk_models` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `speed` varchar(255) default NULL,
  `capacity` int(11) default NULL,
  `part_number` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `interfaces` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `primary` tinyint(1) default NULL,
  `description` text,
  `ip` varchar(255) default NULL,
  `asset_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `mac` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `memory_details` (
  `id` int(11) NOT NULL auto_increment,
  `asset_id` int(11) default NULL,
  `memory_model_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `memory_models` (
  `id` int(11) NOT NULL auto_increment,
  `speed` varchar(255) default NULL,
  `mtype` varchar(255) default NULL,
  `capacity` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `cpu_details` (
  `id` int(11) NOT NULL auto_increment,
  `asset_id` int(11) default NULL,
  `cpu_model_id` int(11) default NULL,
  `socket` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cpu_models` (
  `id` int(11) NOT NULL auto_increment,
  `ctype` varchar(255) default NULL,
  `speed` varchar(255) default NULL,
  `number` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `network_models` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `networks` (
  `id` int(11) NOT NULL auto_increment,
  `network_model_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `pdu_models` (
  `id` int(11) NOT NULL auto_increment,
  `part_number` varchar(255) default NULL,
  `manufacture` varchar(255) default NULL,
  `receptible` int(11) default NULL,
  `voltage` varchar(255) default NULL,
  `ampere` varchar(255) default NULL,
  `wattage` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `pdus` (
  `id` int(11) NOT NULL auto_increment,
  `consumption` int(11) default NULL,
  `pdu_model_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `server_models` (
  `id` int(11) NOT NULL auto_increment,
  `manufacture` varchar(255) default NULL,
  `model` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

CREATE TABLE `servers` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `state` varchar(255) default NULL,
  `server_model_id` int(11) default NULL,
  `service_tag` varchar(255) default NULL,
  `bios_version` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `states` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `storages` (
  `id` int(11) NOT NULL auto_increment,
  `raid_type` varchar(255) default NULL,
  `controller` varchar(255) default NULL,
  `enclosure` varchar(255) default NULL,
  `os` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `vip_servers` (
  `id` int(11) NOT NULL auto_increment,
  `vip_asset_id` int(11) default NULL,
  `asset_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `port` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `vips` (
  `id` int(11) NOT NULL auto_increment,
  `hoster_id` int(11) default NULL,
  `port` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `proto` varchar(255) default NULL,
  `flag` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

INSERT INTO `schema_info` (version) VALUES (35)