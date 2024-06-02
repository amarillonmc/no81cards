--枢机神官·傀儡之紫
local cm,m,o=GetID()
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2,2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.thcon)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #hg>5 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=hg:Select(tp,hg-5,hg-5,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local ng=Duel.GetOperatedGroup()
		local m=0
		if #ng:Filter(Card.IsSetCard,nil,0x647)>=3 then
			m=1
		end
		e:SetLabel(#ng,m)
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local num,ty=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,num,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and ty==1 then
			local rg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil):RandomSelect(tp,1)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end