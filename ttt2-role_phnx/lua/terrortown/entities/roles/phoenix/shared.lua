if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_phoenix.vmt")
end

function ROLE:PreInitialize()
  self.color = Color(98, 161, 74, 255)

  self.abbr = "phnx" -- abbreviation
  self.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
  self.score.killsMultiplier = 2 -- multiplier for kill of player of another team
  self.score.teamKillsMultiplier = -8 -- multiplier for teamkill
  self.unknownTeam = true

  self.defaultTeam = TEAM_INNOCENT

  self.conVarData = {
    pct = 0.17, -- necessary: percentage of getting this role selected (per player)
    maximum = 1, -- maximum amount of roles in a round
    minPlayers = 6, -- minimum amount of players until this role is able to get selected
    credits = 0, -- the starting credits of a specific role
    togglable = true, -- option to toggle a role for a client if possible (F1 menu)
    random = 20,
    traitorButton = 0, -- can use traitor buttons
    shopFallback = SHOP_DISABLED
  }
end

-- now link this subrole with its baserole
function ROLE:Initialize()
  roles.SetBaseRole(self, ROLE_INNOCENT)
end

if SERVER then
	function ENT:PhysicsCollide( data, phys )
		if CORPSE.IsRealPlayerCorpse( phys ) then
			print("corpse collided with something: " .. data.HitEntity)
		end
	end
end