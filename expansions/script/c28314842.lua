--闪耀的萤火 福丸小糸
function c28314842.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28314842,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28314842)
	e1:SetCondition(c28314842.spcon)
	e1:SetTarget(c28314842.sptg)
	e1:SetOperation(c28314842.spop)
	c:RegisterEffect(e1)
	--noctchill dice
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetProperty(EFFECT_FLAG_DICE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38314842)
	e2:SetTarget(c28314842.dctg)
	e2:SetOperation(c28314842.dcop)
	c:RegisterEffect(e2)
	--noctchill dice change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TOSS_DICE_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c28314842.diceop)
	c:RegisterEffect(e3)
--c28314842.toss_dice=true
end
function c28314842.cfilter(c)
	return c:IsSetCard(0x289) and c:IsFaceup()
end
function c28314842.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28314842.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c28314842.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28314842.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28314842.pfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x28a) and not c:IsForbidden()
end
function c28314842.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c28314842.pfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c28314842.dcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.TossDice(tp,1)==6 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)==0 then return end
		if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) and Duel.IsExistingMatchingCard(c28314842.pfilter,tp,LOCATION_DECK,0,2,nil)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c28314842.pfilter,tp,LOCATION_DECK,0,2,2,nil)
		for pc in aux.Next(g) do
			Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c28314842.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if re:GetHandler():IsSetCard(0x289) and rp==tp and Duel.GetDiceResult()==2 and Duel.SelectYesNo(tp,aux.Stringid(28314842,2)) then
		Duel.Hint(HINT_CARD,0,28314842)
		Duel.SetDiceResult(6)
	end
end
