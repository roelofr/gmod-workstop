--[[
	Disables the workshop
	This file simply adds the client-side file and adds some convars

	This work is licensed under the GNU General Public Licene version 3.
	The source code is available at https://github.com/roelofr/gmod-workstop
]]--


CreateConVar( "workshop_disable_url", "", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "The webpage to show on the workshop tabs" )
AddCSLuaFile( "autorun/client/cl_workshop_disabler.lua" )

print( " --[ Workshop disabler loaded ]-- " )
