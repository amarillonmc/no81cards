--溟海捕食者 希伏契
function c95101145.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101145,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,95101145)
	e1:SetCost(c95101145.spcost)
	e1:SetTarget(c95101145.sptg)
	e1:SetOperation(c95101145.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95101145,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,95101145+1)
	e2:SetCondition(c95101145.thcon)
	e2:SetTarget(c95101145.thtg)
	e2:SetOperation(c95101145.thop)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101145,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,95101145+2)
	e3:SetCost(c95101145.accost)
	e3:SetTarget(c95101145.actg)
	e3:SetOperation(c95101145.acop)
	c:RegisterEffect(e3)
	--counter
	Duel.AddCustomActivityCounter(95101145,ACTIVITY_SPSUMMON,c95101145.counterfilter)
end
function c95101145.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c95101145.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGraveAsCost()
end
function c95101145.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101145.tgfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end-- and Duel.GetCustomActivityCount(95101145,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.DiscardHand(tp,c95101145.tgfilter,1,1,REASON_COST,e:GetHandler())
end
function c95101145.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c95101145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101145.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c95101145.splimit)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95101145.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() --and c:GetOriginalType()&TYPE_MONSTER>0 and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
function c95101145.thfilter(c)
	return c:IsSetCard(0xbbd) and not c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95101145.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101145.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95101145.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c95101145.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c95101145.disfilter(c,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c95101145.acfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,tp,0)
end
function c95101145.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101145.disfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.DiscardHand(tp,c95101145.disfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp)
end
function c95101145.acfilter(c,tp,chk)
	return c:IsSetCard(0xbbf) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
		and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
		and (chk==0 or aux.NecroValleyFilter()(c))
end
function c95101145.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101145.acfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp,0) end
end
function c95101145.acop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95101145.acfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp,1)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c95101145.acfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp,1):GetFirst()
		if tc then
			local field=tc:IsType(TYPE_FIELD)
			if field then
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			if field then
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			end
		end
	end
end
