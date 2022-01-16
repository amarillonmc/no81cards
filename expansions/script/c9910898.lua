--悲歌的奥斯忒茜
function c9910898.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
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
function c9910898.spfilter(c,e,tp)
	return aux.IsCodeListed(c,9910871)
		and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
		or (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)))
end
function c9910898.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g0=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE):Filter(Card.IsType,nil,TYPE_MONSTER)
	local g=Duel.GetMatchingGroup(c9910898.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g0 and g0:GetClassCount(Card.GetRace)>=3 and g:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910898,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
			local op=0
			if b1 and b2 then
				op=Duel.SelectOption(tp,aux.Stringid(9910898,1),aux.Stringid(9910898,2))
			elseif b1 then
				op=Duel.SelectOption(tp,aux.Stringid(9910898,1))
			elseif b2 then
				op=Duel.SelectOption(tp,aux.Stringid(9910898,2))+1
			else return end
			if op==0 then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
			end
		end
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
