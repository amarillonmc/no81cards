--来自三千万年前的讯息
if not pcall(function() require("expansions/script/c25000024") end) then require("script/c25000024") end
local m,cm=rscf.DefineCard(25000026)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,{m,0},{1,m},"sp",nil,nil,nil,rsop.target(rscf.spfilter2(rsoc.IsSet),"sp",LOCATION_DECK),cm.spop)
	local e2=rsef.ACT(c,nil,{m,1},{1,m},"se,th",nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e3=aux.AddRitualProcGreater2Code2(c,25000031,25000032,nil,nil,aux.TRUE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCost(aux.bfgcost)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m+100)
	e3:SetDescription(aux.Stringid(m,0))
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(cm.handcon)
	c:RegisterEffect(e4)
end
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,rscf.spfilter2(rsoc.IsSet),tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end
function cm.thfilter(c)
	return rsoc.IsSetST(c) and c:IsAbleToHand() 
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end