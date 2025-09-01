--星绘·澪
function c11185105.initial_effect(c)
	aux.AddMaterialCodeList(c,11185070,11185080)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,11185070),aux.FilterBoolFunction(Card.IsCode,11185080),1,1)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,11185105)
	e1:SetCost(c11185105.spcost)
	e1:SetTarget(c11185105.sptg)
	e1:SetOperation(c11185105.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,11185105+1)
	e2:SetCondition(c11185105.thcon)
	e2:SetCost(c11185105.thcost)
	e2:SetTarget(c11185105.thtg)
	e2:SetOperation(c11185105.thop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,90276651)
	e3:SetCountLimit(1,11185105+2)
	e3:SetTarget(c11185105.pentg)
	e3:SetOperation(c11185105.penop)
	c:RegisterEffect(e3)
end
function c11185105.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x452,1,REASON_COST)
end
function c11185105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11185125,0x452,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11185105.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,11185125,0x452,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,11185125)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11185105.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c11185105.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x452,2,REASON_COST)
end
function c11185105.thfilter(c)
	return c:IsSetCard(0x452) and c:IsAbleToHand()
end
function c11185105.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185105.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c11185105.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11185105.thfilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()==2 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11185105.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11185130,0x452,0x5011,0,0,3,RACE_FAIRY,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11185105.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			if Duel.IsPlayerCanSpecialSummonMonster(tp,11185130,0x452,0x5011,0,0,3,RACE_FAIRY,ATTRIBUTE_WATER) then
				Duel.BreakEffect()
				local token=Duel.CreateToken(tp,11185130)
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end