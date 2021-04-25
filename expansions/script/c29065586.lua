--方舟骑士·灰喉
function c29065586.initial_effect(c)
	c:EnableCounterPermit(0x11ae)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065586,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065586)
	e1:SetCost(c29065586.spcost)
	e1:SetTarget(c29065586.sptg)
	e1:SetOperation(c29065586.spop)
	c:RegisterEffect(e1)   
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065586,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,29000013)
	e2:SetTarget(c29065586.thtg1)
	e2:SetOperation(c29065586.thop1)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065586.summon_effect=e2
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29065586,3))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,29000014)
	e4:SetCondition(c29065586.thcon)
	e4:SetTarget(c29065586.thtg)
	e4:SetOperation(c29065586.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e5)
end
function c29065586.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x11ae,1,REASON_COST) or Duel.IsPlayerAffectedByEffect(tp,29065592) end
	if Duel.IsPlayerAffectedByEffect(tp,29065592) and (not Duel.IsCanRemoveCounter(tp,1,0,0x11ae,1,REASON_COST) or Duel.SelectYesNo(tp,aux.Stringid(29065592,0))) then
	Duel.RegisterFlagEffect(tp,29065592,RESET_PHASE+PHASE_END,0,1)
	else
	Duel.RemoveCounter(tp,1,0,0x11ae,1,REASON_COST)
	end
end
function c29065586.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c29065586.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29065586.xthfilter(c)
	return c:IsSetCard(0x87af) and not c:IsCode(29065586) and c:IsAbleToHand()
end
function c29065586.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065586.xthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c29065586.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065586.xthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end
function c29065586.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c29065586.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsCanAddCounter(0x11ae,1)
end
function c29065586.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065586.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c29065586.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c29065586.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x11ae,n)
end












