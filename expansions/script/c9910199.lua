--遥望天空的少女
function c9910199.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910198)
	e1:SetCondition(c9910199.spcon1)
	e1:SetTarget(c9910199.sptg1)
	e1:SetOperation(c9910199.spop1)
	c:RegisterEffect(e1)
	--spsummon / link summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910199)
	e2:SetTarget(c9910199.sptg2)
	e2:SetOperation(c9910199.spop2)
	c:RegisterEffect(e2)
end
function c9910199.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and eg:IsExists(Card.IsControler,1,nil,tp)
end
function c9910199.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910199.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910199.filter(c,loc)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and bit.band(c:GetSummonLocation(),loc)~=0
end
function c9910199.spfilter(c,e,tp)
	return c:IsCode(9910199) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910199.lkfilter(c)
	return c:IsLinkSummonable(nil)
end
function c9910199.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc1=LOCATION_HAND+LOCATION_GRAVE 
	local loc2=LOCATION_DECK+LOCATION_EXTRA 
	local b1=Duel.IsExistingMatchingCard(c9910199.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,loc1)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910199.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c9910199.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,loc2)
		and Duel.IsExistingMatchingCard(c9910199.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c9910199.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc1=LOCATION_HAND+LOCATION_GRAVE 
	local loc2=LOCATION_DECK+LOCATION_EXTRA 
	local b1=Duel.IsExistingMatchingCard(c9910199.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,loc1)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910199.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c9910199.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,loc2)
		and Duel.IsExistingMatchingCard(c9910199.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
	local res=0
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c9910199.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			res=Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if b2 then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c9910199.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g2:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end
	end
end
