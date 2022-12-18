--扎丝带的清姬
function c22022370.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22022370+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22022370.spcon)
	e1:SetTarget(c22022370.sptg)
	e1:SetOperation(c22022370.spop)
	c:RegisterEffect(e1)
end
function c22022370.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCode(22020000)
end
function c22022370.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22022370.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c22022370.spfilter(c,e,tp)
	return c:IsCode(22020010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22022370.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22022370.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c22022370.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22022370.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.SelectOption(tp,aux.Stringid(22022370,0))
		Duel.SelectOption(tp,aux.Stringid(22022370,1))
		Duel.SelectOption(tp,aux.Stringid(22022370,2))
		Duel.SelectOption(tp,aux.Stringid(22022370,3))
		Duel.SelectOption(tp,aux.Stringid(22022370,4))
		Duel.SelectOption(tp,aux.Stringid(22022370,5))
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
