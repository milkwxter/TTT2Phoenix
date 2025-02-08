-- my variables
local isPhoenixReviving = false
local phoenixBodies = {}

-- my hooks
if SERVER then
	hook.Add( "TTTOnCorpseCreated", "TTT2PhoenixBodyCreated", function(rag, ply)
		-- make sure its a real corpse
		if not CORPSE.IsRealPlayerCorpse(rag) then
			print("[REALLY BAD] Entity was not a real player corpse.")
			return
		end
		
		-- logic
		print(ply:Nick() .. " has died and their corpse is now a ragdoll! " .. ply:GetRoleStringRaw())
		
		if ply:GetSubRole() == ROLE_PHOENIX then
			print(ply:Nick() .. " was also a Phoenix!")
			table.insert(phoenixBodies, rag)
		end
	end )
	
	hook.Add("Think", "TTT2CheckPhoenixBodies", function()
        for _, rag in ipairs(phoenixBodies) do
            if rag:IsOnFire() then
                print("Ahhh! Phoenix on fire!")
            end
        end
    end)
end