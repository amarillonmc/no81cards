--过去的魔女 库瓦希尔
local s,id,o=GetID()
function c75081151.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c75081151.negcon)
	e1:SetOperation(c75081151.negop)
	c:RegisterEffect(e1)  
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081151,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,75081151)
	e2:SetCondition(c75081151.thcon)
	e2:SetTarget(c75081151.thtg)
	e2:SetOperation(c75081151.thop)
	c:RegisterEffect(e2)  
	--Send to extra
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75081151,3))
	e4:SetCategory(CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,75081152)
	e4:SetCondition(c75081151.tecon)
	e4:SetTarget(c75081151.tetg)
	e4:SetOperation(c75081151.teop)
	c:RegisterEffect(e4) 
end
function c75081151.negcon(e,tp,eg,ep,ev,re,r,rp)
	if ev<2 then return false end
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return rp==1-tp and te and te:GetHandler():IsSetCard(0x6754) 
		and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetFlagEffect(tp,id)==0
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
end
function c75081151.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)==0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
--
function c75081151.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_HAND)
end
function c75081151.thfilter(c)
	return c:IsSetCard(0x6754) and c:IsAbleToHand()
end
function c75081151.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75081151.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75081151.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75081151.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c75081151.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x6754)
end
function c75081151.tecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c75081151.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75081151.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c75081151.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75081151,5))
	local g=Duel.SelectMatchingCard(tp,c75081151.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end