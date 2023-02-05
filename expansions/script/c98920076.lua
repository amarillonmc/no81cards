--急袭猛禽-原型林鸮
function c98920076.initial_effect(c)
		--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920076,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98920076)
	e2:SetCost(c98920076.thcost)
	e2:SetTarget(c98920076.thtg)
	e2:SetOperation(c98920076.thop)
	c:RegisterEffect(e2)  
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,98930076)
	e1:SetCondition(c98920076.spcon1)
	e1:SetTarget(c98920076.sptg1)
	e1:SetOperation(c98920076.spop1)
	c:RegisterEffect(e1)
end
function c98920076.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c98920076.thfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c98920076.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920076.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920076.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c98920076.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920076.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920076.splimit(e,c)
	return not c:IsRace(RACE_WINDBEAST) and c:IsLocation(LOCATION_EXTRA)
end
function c98920076.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and ((c:IsPreviousSetCard(0xba) and bit.band(c:GetPreviousTypeOnField(),TYPE_XYZ)~=0))
		and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c98920076.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920076.cfilter,1,nil,tp)
end
function c98920076.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920076.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end