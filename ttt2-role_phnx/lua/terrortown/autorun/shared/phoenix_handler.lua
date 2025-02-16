-- my variables
local phoenixBodies = {}

-- my hooks
if SERVER then
	hook.Add("TTTOnCorpseCreated", "TTT2PhoenixBodyCreated", function(rag, ply)
		-- make sure its a real corpse
		if not CORPSE.IsRealPlayerCorpse(rag) then
			return
		end
		
		-- logic
		if ply:GetSubRole() == ROLE_PHOENIX then
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
			
			-- check for nearby fires (vanilla implementation)
			local foundFlame = false
			local nearbyEnts = ents.FindInSphere(rag:GetPos(), 50)
			for _, ent in pairs(nearbyEnts) do
				if ent:GetClass() == "ttt_flame" then
					foundFlame = true
					break
				end
			end

			-- if body is on fire OR we found a nearby flame, we revive
            if rag:IsOnFire() or foundFlame == true then
				if not rag:IsOnFire() then
					rag:Ignite(5)
				end
                ply:Revive(5, function(p)
					p:SetHealth(50)
					p:GiveEquipmentItem("item_ttt_nofiredmg")
					table.remove(phoenixBodies, _)
				end, nil, false, REVIVAL_BLOCK_NONE)
            end
        end
    end)
	
	hook.Add("TTTBeginRound", "TTT2CleanupPhoenixBR", function()
		phoenixBodies = {}
	end)
	
	hook.Add("TTTEndRound", "TTT2CleanupPhoenixER", function()
		phoenixBodies = {}
	end)
end