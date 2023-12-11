--雷素电击弹丸龙
function c11634009.initial_effect(c)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11634009,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11634009)
	e1:SetCondition(c11634009.spcon)
	e1:SetTarget(c11634009.sptg)
	e1:SetOperation(c11634009.spop)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11634009,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,116340090)
	e1:SetCondition(c11634009.descon)
	e1:SetTarget(c11634009.destg)
	e1:SetOperation(c11634009.desop)
	c:RegisterEffect(e1)
end
function c11634009.cfilter(c,tp,rp)
	return c:IsReason(REASON_DESTROY) and c:IsRace(RACE_DRAGON) 
end
function c11634009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11634009.cfilter,1,nil,tp,rp)
end
function c11634009.filter(c,e,tp)
	return c:IsSetCard(0x102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11634009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c11634009.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c11634009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11634009.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11634009.spfilter(c,e,tp)
	return c:IsSetCard(0x102) and not c:IsCode(11634009) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11634009.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return re:IsActiveType(TYPE_LINK)
end
function c11634009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11634009.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11634009.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11634009.spfilter),tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		if tc then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end