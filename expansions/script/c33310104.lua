--可可莉柯特·地狱尖啸者
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rsof.DefineCard(33310104,"Cochrot")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=rsef.QO(c,nil,{m,0},{1,m},"se,th,rm,dish,ga",nil,LOCATION_HAND,nil,nil,rsop.target({aux.FilterBoolFunction(Card.IsDiscardable,REASON_EFFECT),"dish",LOCATION_HAND },{cm.thfilter,"th",LOCATION_DECK }),cm.thop) 
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetCondition(cm.con)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)   
	local e6=rsef.STO(c,EVENT_REMOVE,{m,1},{1,m+100},"td","de,dsp",nil,nil,rsop.target(Card.IsAbleToDeck,"td",LOCATION_GRAVE+LOCATION_REMOVED),cm.tdop)
end
function cm.thfilter(c)
	return c:IsCode(33310101) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil,REASON_EFFECT)
	if ct==0 then return end
	rsof.SelectHint(tp,"th")
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g<=0 or Duel.SendtoHand(g,nil,REASON_EFFECT)<=0 then return end
	Duel.ConfirmCards(1-tp,g)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil)
	if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		rsof.SelectHint(tp,"rm")
		rg=rg:Select(tp,1,1,nil)
		rsof.Remove(rg)
	end
end
function cm.con(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.aclimit(e,re,tp)
	return not re:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.tdop(e,tp)
	rsof.SelectHint(tp,"td")
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	rsof.SendtoDeck(g)
end