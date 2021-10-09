--Undead—虚无卡
function c9980495.initial_effect(c)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980495+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9980495.spcon)
	e1:SetTarget(c9980495.sptg)
	e1:SetOperation(c9980495.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980495,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9980495.thtg)
	e2:SetOperation(c9980495.thop)
	c:RegisterEffect(e2)
end
function c9980495.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabca,0x5bcb)
end
function c9980495.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980495.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9980495.tfilter(c,e,tp)
	return c:IsSetCard(0xabca,0x5bcb) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAttackAbove(1000) and c:IsCanBeSpecialSummoned(e,0x8,tp,false,false)
		and not Duel.IsExistingMatchingCard(c9980495.bfilter,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function c9980495.bfilter(c,tc)
	return tc:IsCode(c:GetCode()) and c:IsFaceup()
end
function c9980495.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9980495.tfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9980495.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9980495.tfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0x8,tp,tp,false,false,POS_FACEUP)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9980495.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9980495.splimit(e,c)
	return not c:IsSetCard(0xabca,0x5bcb) and c:IsLocation(LOCATION_EXTRA)
end
function c9980495.thfilter(c)
	return c:IsSetCard(0xabca,0x5bcb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980495.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9980495.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980495.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c9980495.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c9980495.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

