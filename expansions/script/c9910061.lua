--回眸之月神
function c9910061.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910061,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,9910061)
	e1:SetCondition(c9910061.spcon)
	e1:SetTarget(c9910061.sptg)
	e1:SetOperation(c9910061.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910062)
	e2:SetCondition(c9910061.rmcon)
	e2:SetTarget(c9910061.rmtg)
	e2:SetOperation(c9910061.rmop)
	c:RegisterEffect(e2)
end
function c9910061.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c9910061.rmfilter(c)
	return c:IsSetCard(0x9951) and c:IsFaceupEx() and c:IsAbleToRemove()
end
function c9910061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9910061.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910061.rmfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c9910061.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER)
		and (rc:IsLevelAbove(6) or rc:IsRankAbove(6))
end
function c9910061.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and rc:IsRelateToEffect(re)
		and rc:IsAbleToRemove() and not rc:IsLocation(LOCATION_REMOVED) end
	local g=Group.FromCards(c,rc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c9910061.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not c:IsRelateToEffect(e) or not rc:IsRelateToEffect(re) then return end
	local g=Group.FromCards(c,rc)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
