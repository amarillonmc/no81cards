--结晶大剑
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174041)
function cm.initial_effect(c)
	local e0,e1=rsef.ACT_EQUIP(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3 = Scl.CreatePlayerBuffEffect(c, "AddAdditionalEffect", cm.aval, nil, {1, 0}, LOCATION_SZONE, nil, nil, {m, 0})
end
function cm.aval(e,tp,ev,re,rp) 
	local ac = re:GetHandler()
	local c = e:GetHandler()
	return ac:GetEquipGroup():IsContains(c), cm.op, true
end
function cm.op(e, p, eg, ep, ev, re, r, rp, chk)
	if chk == 1 then
		rsop.SelectOperate("des",tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
	end
end