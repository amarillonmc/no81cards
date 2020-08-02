--对邪魂兵器 时空回旋机
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(30001007)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	aux.AddLinkProcedure(c,nil,2,2)
	local e1=rsef.QO(c,nil,{m,0},1,"rm",nil,LOCATION_MZONE,nil,rscost.cost(cm.rmfilter,"rm",LOCATION_HAND+LOCATION_DECK),rsop.target(Card.IsAbleToRemove,"rm",LOCATION_DECK),cm.rmop)
	local e2=rsef.QO(c,nil,{m,1},1,"sp",nil,LOCATION_REMOVED,nil,rscost.cost(Card.IsAbleToDeckOrExtraAsCost,"td",LOCATION_REMOVED,LOCATION_REMOVED,7,7,c),rsop.target(rscf.spfilter2(),"sp"),cm.spop)
end
function cm.rmfilter(c,e,tp)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x920) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,c)
end
function cm.rmop(e,tp)
	local ct,og,tc=rsop.SelectRemove(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil,{})
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	e1:SetCondition(cm.thcon)
	e1:SetOperation(cm.thop)
	e1:SetLabel(0)
	tc:RegisterEffect(e1)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	else e:SetLabel(1) end
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e) 
	if c then rssf.SpecialSummon(c) end
end