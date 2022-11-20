--火之传承
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171018)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m},"sp",nil,nil,nil,rsop.target(rscf.spfilter2(Card.IsCode,m-16),"sp",rsloc.hdg),cm.act)
	local e2=aux.AddRitualProcGreater2(c,aux.FilterBoolFunction(Card.IsCode,m-6),LOCATION_HAND+LOCATION_GRAVE,aux.TRUE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.rit(e2:GetTarget()))
	e2:SetOperation(cm.rit(e2:GetOperation()))
end
function cm.thfilter(c)
	return c:IsCode(m-16) and c:IsAbleToHand()
end
function cm.act(e,tp)
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(rscf.spfilter2(Card.IsCode,m-16)),tp,rsloc.hdg,0,1,1,nil,{},e,tp)
end
function cm.gfilter(tp,g,c)
	local og=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #og>0 and not g:IsExists(Card.IsCode,1,nil,m-17) then return false end
	return true
end
function cm.rit(op)
	return function(...)
		aux.RCheckAdditional=cm.gfilter
		local res=op(...)
		aux.RCheckAdditional=nil
		return res
	end
end
