--夏乡追忆 伊甸筑梦
function c67210108.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--to grave(hand destory)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67210108,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c67210108.tgcon)
	e2:SetOperation(c67210108.tgop)
	c:RegisterEffect(e2)
	--free chain recycle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67210108,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e4:SetCountLimit(1,67210108)
	e4:SetCondition(c67210108.thcon)
	e4:SetTarget(c67210108.thtg)
	e4:SetOperation(c67210108.thop)
	c:RegisterEffect(e4)	
end
function c67210108.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c67210108.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c67210108.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:RandomSelect(tp,1)
		Duel.Hint(HINT_CARD,0,67210108)
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
--
function c67210108.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c67210108.thfilter(c)
	return c:IsSetCard(0x67e) and c:IsAbleToHand()
end
function c67210108.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67210108.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c67210108.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67210108.thfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
