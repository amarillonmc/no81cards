--森罗的幼神 森精
function c98920847.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,99)
	--atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c98920847.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920847,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920847)
	e1:SetCost(c98920847.cost)
	e1:SetTarget(c98920847.target)
	e1:SetOperation(c98920847.operation)
	c:RegisterEffect(e1)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920847,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930847)
	e3:SetTarget(c98920847.mttg)
	e3:SetOperation(c98920847.mtop)
	c:RegisterEffect(e3)
end
function c98920847.atkval(e,c)
	return c:GetOverlayCount()*500
end
function c98920847.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920847.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.IsPlayerCanDiscardDeck(1-tp,1)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
end
function c98920847.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,2) then return end
	Duel.ConfirmDecktop(tp,2)
	Duel.ConfirmDecktop(1-tp,1)	
	local g=Duel.GetDecktopGroup(tp,2)
	local g1=Duel.GetDecktopGroup(1-tp,1)
	g:Merge(g1)
	if g:IsExists(c98920847.filter,1,nil) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Filter(c98920847.filter,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
		g:Sub(sg)
		Duel.Overlay(e:GetHandler(),g)
	else
		Duel.ShuffleDeck(tp)
	end
end
function c98920847.filter(c)
	return c:IsRace(RACE_PLANT)
end
function c98920847.mtfilter(c,e,tp,mc,atk,def)
	return c:IsRankAbove(2) and c:IsAttackBelow(atk) and c:IsDefenseBelow(def) and c:IsRace(RACE_PLANT) and c:IsType(TYPE_MONSTER)	and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c98920847.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c98920847.mtfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetAttack(),c:GetDefense()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920847.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920847.mtfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,c:GetAttack(),c:GetDefense())
		local tc=g:GetFirst()
		if tc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(tc,mg)
			end
			tc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(tc,Group.FromCards(c))
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end