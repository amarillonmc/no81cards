--惑蔓的亚基斯普姆
function c9910891.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910891)
	e1:SetCondition(c9910891.spcon)
	e1:SetTarget(c9910891.sptg)
	e1:SetOperation(c9910891.spop)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910892)
	e2:SetCondition(c9910891.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910891.distg)
	e2:SetOperation(c9910891.disop)
	c:RegisterEffect(e2)
end
function c9910891.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg and sg:GetClassCount(Card.GetRace)>=2
end
function c9910891.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910891.rfilter1(c)
	return aux.IsCodeListed(c,9910871) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function c9910891.rfilter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsReleasableByEffect()
end
function c9910891.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g1=Duel.GetMatchingGroup(c9910891.rfilter1,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c9910891.rfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910891,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg1=g1:Select(tp,1,1,nil)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		if sg1:GetCount()~=2 then return end
		Duel.HintSelection(sg1)
		Duel.Release(sg1,REASON_EFFECT)
	end
end
function c9910891.cfilter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c9910891.cfilter1(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c9910891.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:IsExists(c9910891.cfilter1,1,nil,1-tp) and Duel.GetCurrentChain()==0
		and Duel.IsExistingMatchingCard(c9910891.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9910891.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c9910891.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)==0 then return end
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
