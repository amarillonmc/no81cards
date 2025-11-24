--闪耀的绿宝石 七草日花
function c28315848.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c28315848.reptg)
	e1:SetValue(c28315848.repval)
	e1:SetOperation(c28315848.repop)
	c:RegisterEffect(e1)
	--shhis pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315848,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,28315848)
	e2:SetCondition(c28315848.spcon)
	e2:SetTarget(c28315848.sptg)
	e2:SetOperation(c28315848.spop)
	c:RegisterEffect(e2)
end
function c28315848.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsRace(RACE_FAIRY) and c:IsFaceup()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c28315848.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_DESTROY_CONFIRMED) and eg:IsExists(c28315848.repfilter,1,c,tp) and c:IsDestructable(e) and c:IsAbleToRemove()end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c28315848.repval(e,c)
	return c28315848.repfilter(c,e:GetHandlerPlayer())
end
function c28315848.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT,LOCATION_REMOVED)
end
function c28315848.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c28315848.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28315848.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c28315848.tgfilter(c)
	return aux.IsCodeListed(c,28335405)-- and c:IsAbleToGrave()
end
function c28315848.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c28315848.tgfilter,tp,LOCATION_DECK,0,1,nil) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0) end
end
function c28315848.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsAbleToHand()
	local b2=Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if not c:IsRelateToEffect(e) or not (b1 and b2) then return end
	if c:IsAbleToHand() and (not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetMZoneCount(tp)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		if not c:IsLocation(LOCATION_HAND) then return end
	else
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,c28315848.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Destroy(tg,REASON_EFFECT)
end
