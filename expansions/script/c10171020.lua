--初火之炉
if not pcall(function() dofile("expansions/script/c10171001.lua") end) then dofile("script/c10171001.lua") end
local m,cm=rscf.DefineCard(10171020)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.I(c,{m,0},{1,m},"se,th",nil,LOCATION_FZONE,nil,rsds.cost2(1),rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(m)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
end
function cm.thfilter(c)
	return c:IsCode(m-2,m-1) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	if aux.ExceptThisCard(e) then
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end
