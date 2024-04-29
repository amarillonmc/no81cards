--闪耀的绿宝石 七草日花
function c28315848.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--shhis pendulum return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315848,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,28315848)
	e1:SetCondition(c28315848.recon)
	e1:SetTarget(c28315848.retg)
	e1:SetOperation(c28315848.reop)
	c:RegisterEffect(e1)
	--shhis spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315848,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,38315848)
	e2:SetCondition(c28315848.spcon)
	e2:SetTarget(c28315848.sptg)
	e2:SetOperation(c28315848.spop)
	c:RegisterEffect(e2)
	--shhis pendulum check
	Duel.AddCustomActivityCounter(28315848,ACTIVITY_SPSUMMON,c28315848.counterfilter)
end
function c28315848.counterfilter(c)
	return not (c:IsSetCard(0x283) and c:IsSummonType(SUMMON_TYPE_PENDULUM))
end
function c28315848.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(28315848,tp,ACTIVITY_SPSUMMON)>0
end
function c28315848.rthfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToHand() and c:IsFaceup()
end
function c28315848.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315848.rthfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c28315848.disfilter(c)
	return c:IsCode(28335405) and c:IsDiscardable(REASON_EFFECT+REASON_DISCARD)
end
function c28315848.reop(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if Duel.SendtoHand(pg,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c28315848.rthfilter,tp,LOCATION_REMOVED,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c28315848.rthfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(c28315848.disfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28315848,3)) then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,c28315848.disfilter,1,1,REASON_EFFECT+REASON_DISCARD)
		else
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_PZONE,0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c28315848.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0x283) and c:IsFaceup()
end
function c28315848.nckfilter(c)
	return c:IsCode(28317054) and c:IsFaceup()
end
function c28315848.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28315848.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c28315848.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if Duel.IsExistingMatchingCard(c28315848.nckfilter,tp,LOCATION_MZONE,0,1,nil) then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	end
end
function c28315848.tgfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToGrave()
end
function c28315848.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c28315848.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28315848,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=Duel.SelectMatchingCard(tp,c28315848.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end
