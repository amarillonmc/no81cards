--悲歌的奥斯忒茜
function c9910898.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910898)
	e1:SetCondition(c9910898.spcon)
	e1:SetTarget(c9910898.sptg)
	e1:SetOperation(c9910898.spop)
	c:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910899)
	e2:SetCondition(c9910898.atcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c9910898.atop)
	c:RegisterEffect(e2)
end
function c9910898.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg and sg:GetClassCount(Card.GetRace)>=2
end
function c9910898.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910898.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c9910898.desfilter(c)
	return aux.IsCodeListed(c,9910871) and c:IsType(TYPE_MONSTER)
end
function c9910898.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetMatchingGroup(c9910898.desfilter,tp,LOCATION_HAND,0,nil)
	if Duel.IsExistingMatchingCard(c9910898.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and #g1>0 and #g2>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910898,0)) then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,g1)
		if not g1:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg1=g1:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
		local sg2=g2:FilterSelect(tp,c9910898.desfilter,1,1,nil)
		sg1:Merge(sg2)
		if sg1:GetCount()~=2 then return end
		Duel.HintSelection(sg1)
		Duel.Destroy(sg1,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
function c9910898.cfilter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsRace(RACE_FISH)
end
function c9910898.atcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsChainAttackable(0)
		and Duel.IsExistingMatchingCard(c9910898.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9910898.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
