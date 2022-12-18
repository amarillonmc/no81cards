--战车道计策·远程轰炸
function c9910126.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK)
	c:RegisterEffect(e1)
	--destroy when chaining
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c9910126.descon1)
	e2:SetCost(c9910126.descost)
	e2:SetTarget(c9910126.destg1)
	e2:SetOperation(c9910126.desop1)
	c:RegisterEffect(e2)
	--destroy when attack
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c9910126.descon2)
	e4:SetCost(c9910126.descost)
	e4:SetTarget(c9910126.destg2)
	e4:SetOperation(c9910126.desop2)
	c:RegisterEffect(e4)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_HANDES+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCountLimit(1,9910126)
	e6:SetCondition(c9910126.thcon)
	e6:SetTarget(c9910126.thtg)
	e6:SetOperation(c9910126.thop)
	c:RegisterEffect(e6)
end
function c9910126.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c9910126.descon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function c9910126.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c9910126.desop1(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c9910126.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c9910126.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():IsRelateToBattle() end
	Duel.SetTargetCard(Duel.GetAttacker())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker(),1,0,0)
end
function c9910126.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c9910126.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c9910126.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910126.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c9910126.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		local hg=g:RandomSelect(tp,1)
		if Duel.SendtoGrave(hg,REASON_DISCARD+REASON_EFFECT)~=0 then
			local sg=Duel.GetMatchingGroup(c9910126.thfilter,tp,LOCATION_DECK,0,nil)
			if sg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tg=sg:Select(tp,1,1,nil)
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
		end
	end
end
