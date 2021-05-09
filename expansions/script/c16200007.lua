--单推人不单推
function c16200007.initial_effect(c)
	aux.AddCodeList(c,16200003)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16200007)
	e1:SetCondition(c16200007.condition1)
	e1:SetTarget(c16200007.target1)
	e1:SetOperation(c16200007.activate1)
	c:RegisterEffect(e1)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c16200007.handcon)
	c:RegisterEffect(e0)
end
function c16200007.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c16200007.handcon(e)
	return not Duel.IsExistingMatchingCard(c16200007.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c16200007.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c16200007.pfilter(c)
	return aux.IsCodeListed(c,16200003) and c:IsAbleToHand()
end
function c16200007.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16200007.pfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end
function c16200007.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local sg=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmDecktop(tp,3)
	local g=sg:Filter(c16200007.pfilter,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end