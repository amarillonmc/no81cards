--Speedster Quick
function c31034001.initial_effect(c)
	aux.AddCodeList(c, 31034011)
	--add speedgear/accel
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, 31034001)
	e1:SetTarget(c31034001.target)
	e1:SetOperation(c31034001.operation)
	c:RegisterEffect(e1)
	--special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1, 31034002)
	e2:SetCondition(c31034001.spcon)
	e2:SetTarget(c31034001.sptg)
	e2:SetOperation(c31034001.spop)
	c:RegisterEffect(e2)
end

function c31034001.filter(c)
	return (c:IsCode(31034011) or (c:IsSetCard(0x892) and c:IsType(TYPE_MONSTER))) and c:IsAbleToHand()
end

function c31034001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(c31034001.filter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function c31034001.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp, c31034001.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end

function c31034001.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) 
		and bit.band(c:GetPreviousAttributeOnField(), ATTRIBUTE_WIND)~=0 and bit.band(c:GetPreviousTypeOnField(), TYPE_SYNCHRO)~=0
end

function c31034001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c31034001.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end

function c31034001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function c31034001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
end


