--仗剑走天涯 阿福
function c50099155.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Special Summon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,50099155)
	e1:SetCost(c50099155.spcost)
	e1:SetTarget(c50099155.sptg)
	e1:SetOperation(c50099155.spop)
	c:RegisterEffect(e1)
	--place in pzone
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10099155)
	e2:SetCondition(c50099155.pzcon)
	e2:SetTarget(c50099155.pztg)
	e2:SetOperation(c50099155.pzop)
	c:RegisterEffect(e2)   
	--remove 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,20099155) 
	e3:SetCondition(c50099155.rmcon)
	e3:SetTarget(c50099155.rmtg)
	e3:SetOperation(c50099155.rmop)
	c:RegisterEffect(e3) 
end
function c50099155.costfilter(c)
	return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c50099155.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c50099155.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c50099155.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50099155.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50099155.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c50099155.pzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function c50099155.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c50099155.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
	end
end
function c50099155.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x998)
end
function c50099155.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50099155.cfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function c50099155.rmfilter(c)
	return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c50099155.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50099155.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c50099155.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.SelectMatchingCard(tp,c50099155.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	end
end

