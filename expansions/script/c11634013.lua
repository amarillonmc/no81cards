--崇高弹丸龙
function c11634013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11634013,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11634013+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11634013.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11634013,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,116340130)
	e1:SetCondition(c11634013.descon)
	e1:SetTarget(c11634013.destg)
	e1:SetOperation(c11634013.desop)
	c:RegisterEffect(e1)
end
function c11634013.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c11634013.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11634013.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c11634013.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return re:IsActiveType(TYPE_LINK)
end
function c11634013.setfilter(c)
	return c:IsCode(44095762,62279055) and c:IsSSetable()
end
function c11634013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c11634013.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c11634013.filter2(c,e,tp)
	return c:IsSetCard(0x102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11634013.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c11634013.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SSet(tp,g:GetFirst())~=0 then
		local tc=Duel.GetMatchingGroup(c11634013.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
		if tc and Duel.SelectYesNo(tp,aux.Stringid(11634013,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=tc:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
		end
	end
	end
end