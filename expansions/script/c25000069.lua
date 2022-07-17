local m=25000069
local cm=_G["c"..m]
cm.name="彷徨的灵魂"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetCurrentChain()==0 end)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)<5 end)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():IsSummonPlayer(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function cm.nfilter(c,tc)
	return c:IsCode(tc:GetPreviousCodeOnField()) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	Duel.NegateSummon(tc)
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_DECK,0,nil,tc)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hc=g:Select(tp,1,1,nil):GetFirst()
		if hc then
			Duel.SendtoHand(hc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hc)
		end
	end
end
