--空想星界 星辉沼地
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl_Utoland.FieldEffects(c, id, nil, s.tg, 1, 2)
end
function s.cfilter(c,tp)
	return Scl_Utoland.SpecialSummonTokenAble(tp, c, 1, 2)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg = Scl_Utoland.GetTributeGroup(tp)
	if chk==0 then 
	   if e:IsCostChecked() then
		  return rg:IsExists(s.cfilter,1,nil,tp)
	   else 
		  local res = Scl_Utoland.SpecialSummonTokenAble(tp, nil, 1, 2)
		  return res
	   end
	end
	if e:IsCostChecked() then
		Scl.SelectAndOperateCardsFromGroup("Tribute",rg,tp,aux.TRUE,1,1,nil)(REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
