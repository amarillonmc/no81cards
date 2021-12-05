local m=53799140
local cm=_G["c"..m]
cm.name="救济之法"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_CANNOT_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e7)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(2800)
end
function cm.fselect(g)
	return g:IsExists(cm.cfilter,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local rg=g:SelectSubGroup(tp,cm.fselect,false,2,2)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(m)==0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev)
		local c=e:GetHandler()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
