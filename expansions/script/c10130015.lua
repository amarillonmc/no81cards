--ZX·Ω
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	Scl.SetSummonCondition(c, true, aux.FALSE)
	aux.AddFusionProcFunRep2(c,s.ffilter,2,99,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE+LOCATION_GRAVE,0,s.sprop(c))
end
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0xa336) and c:IsFusionType(TYPE_MONSTER) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function s.sprop(c)
	return  function(g)
				if Duel.Remove(g,POS_FACEUP,REASON_COST) > 0 then
					local ct = Scl.GetCorrectlyOperatedCount("Banished")
					local e1 = Scl.CreateSingleBuffEffect({c,c,true}, "=BaseATK", ct*1500, "MonsterZone", nil, RESET_EVENT+0xff0000)
					local e2 = Scl.CreateSingleBuffEffect({c,c,true}, "=BaseDEF", ct*1500, "MonsterZone", nil, RESET_EVENT+0xff0000) 
					local e3 = Scl.CreateSingleBuffEffect({c,c,true}, "+AttackMonsterCount", ct - 1, "MonsterZone", nil, RESET_EVENT+0xff0000) 
				end
			end
end
