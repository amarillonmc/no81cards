--时空运输
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(30001009)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.I(c,{m,0},1,"rm",nil,LOCATION_SZONE,nil,nil,rsop.target(cm.rmfilter,"rm",LOCATION_DECK+LOCATION_GRAVE),cm.rmop)
	local e3=rsef.I(c,{m,1},{1,m},"rm",nil,LOCATION_SZONE,cm.rmcon2,nil,rsop.target(Card.IsAbleToRemove,"rm",LOCATION_DECK),cm.rmop2)
	local e4=rsef.STO(c,EVENT_REMOVE,{m,2},{1,m+100},nil,"de,dsp",cm.tfcon,nil,nil,cm.tfop)
	local e5=rsef.RegisterOPTurn(c,e2,cm.quickcon)
	local e6=rsef.RegisterOPTurn(c,e3,cm.quickcon)
end
function cm.rmfilter(c)
	return c:IsSetCard(0x920) and c:IsAbleToRemove() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.rmop(e,tp)
	if not rscf.GetSelf(e) then return end
	rsop.SelectRemove(tp,cm.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,{})
end
function cm.cfilter(c)
	return c:IsSetCard(0x920) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.rmcon2(e,tp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function cm.rmop2(e,tp)
	if not rscf.GetSelf(e) then return end
	rsop.SelectRemove(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.tfcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.tfop(e,tp)
	local c=rscf.GetSelf(e) 
	if c and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.quickcon(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,30000010)
end