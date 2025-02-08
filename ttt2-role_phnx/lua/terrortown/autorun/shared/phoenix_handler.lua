-- my variables
local phoenixBodies = {}

-- my hooks
if SERVER then
	hook.Add("TTTOnCorpseCreated", "TTT2PhoenixBodyCreated", function(rag, ply)
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
		-- iterate through all our phoenix bodies
        for _, rag in ipairs(phoenixBodies) do
			-- store the current player of the phoenix body
			local ply = CORPSE.GetPlayer(rag)
			-- early return statements
			if ply:IsReviving() then return end
			-- if body is on fire, we revive
            if rag:IsOnFire() then
				print("Revival should start.")
                ply:Revive(3, function(p)
					p:SetHealth(50)
					p:GiveEquipmentItem("item_ttt_nofiredmg")
					print("Revival done.")
					table.remove(phoenixBodies, _)
				end, nil, false, REVIVAL_BLOCK_NONE)
            end
        end
    end)
	
	hook.Add("TTTEndRound", "TTT2CleanupPhoenix", function()
		phoenixBodies = {}
	end)
end