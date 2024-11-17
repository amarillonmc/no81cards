--工坊武器·阿拉斯工坊
function c65820045.initial_effect(c)
	aux.AddCodeList(c,65820000,65820005)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65820045,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65820045+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65820045.target)
	e1:SetOperation(c65820045.activate)
	c:RegisterEffect(e1)
	--康
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65820045,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,65820045+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c65820045.setcon)
	e2:SetTarget(c65820045.settg)
	e2:SetOperation(c65820045.setop)
	c:RegisterEffect(e2)
end



function c65820045.spfilter(c,e,tp)
	return c:IsCode(65820000,65820005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.NecroValleyFilter()
end
function c65820045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65820045.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED)
end
function c65820045.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65820045.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65820045.filter(c,e,tp)
	return c:IsCode(65820000,65820005) and c:IsFaceup()
end
function c65820045.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65820045.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsChainDisablable(ev)
end
function c65820045.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c65820045.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() and Duel.NegateEffect(ev) and tc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
