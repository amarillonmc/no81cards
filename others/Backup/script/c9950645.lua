--凯尔特·晨星之子
function c9950645.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950645+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9950645.spcon)
	e1:SetTarget(c9950645.sptg)
	e1:SetOperation(c9950645.spop)
	c:RegisterEffect(e1)
end
function c9950645.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950645.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950645.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9950645.tfilter(c,e,tp)
	return c:IsSetCard(0x6ba2) and c:IsCanBeSpecialSummoned(e,0x8,tp,false,false)
		and not Duel.IsExistingMatchingCard(c9950645.bfilter,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function c9950645.bfilter(c,tc)
	return tc:IsCode(c:GetCode()) and c:IsFaceup()
end
function c9950645.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950645.tfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9950645.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9950645.tfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
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
	e1:SetTarget(c9950645.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9950645.splimit(e,c)
	return not c:IsSetCard(0xba5) and c:IsLocation(LOCATION_EXTRA)
end

