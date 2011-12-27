preloadlist(
{
	assassin = {
		'units.class.assassin.lua',
	},
	electrician = {
		'units.class.electrician',
		'units.other.drainable',
	},
	commonenemies = {
		'units.enemies.box.lua',
	},
	tibet = {
		'units.enemies.ial',
		'units.enemies.bosshans'
	},
	waterloo = {
		'units.enemies.insectoid',
		'units.enemies.mech',
		'units.enemies.spiderjason',
		'units.other.waterloo',
	},
	swift = {
		'units.class.swift',
		'units.class.chain'
	},
	vancouver = {
		'units.other.vancouver'
	},
	stealth = {
		'units.other.stealth'
	},
	whistler = {
		'units.other.whistler',
		'units.enemies.dungeon',
		'units.other.switchplate',
		'units.other.guardian',
		'units.enemies.bossreaper',
		'units.other.lightpuzzleunit'
	}
}
)

require 'units.other.doodad'
--[[
require ('units.enemies.box.lua')
require "units.enemies.lizardguard"

--require ('units.missiles.pistol.lua')

require ('units.class.assassin.lua')
require 'units.class.electrician'
require 'units.enemies.ial'
require 'units.enemies.bosshans'


require 'units.other.drainable'
]]