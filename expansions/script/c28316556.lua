--闪耀的萤火 市川雏菜
function c28316556.initial_effect(c)
	aux.AddCodeList(c,28316050)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316556,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316556)
	e1:SetCondition(c28316556.spcon)
	e1:SetTarget(c28316556.sptg)
	e1:SetOperation(c28316556.spop)
	c:RegisterEffect(e1)
	--noctchill dice
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316556)
	e2:SetTarget(c28316556.dctg)
	e2:SetOperation(c28316556.dcop)
	c:RegisterEffect(e2)
	--noctchill dice change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TOSS_DICE_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c28316556.diceop)
	c:RegisterEffect(e3)
c28316556.toss_dice=true
end
function c28316556.cfilter(c)
	return c:IsCode(28316050) and c:IsFaceup()
end
function c28316556.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28316556.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c28316556.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28316556.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28316556.thfilter(c)
	return c:IsSetCard(0x283) and c:IsFaceupEx() and c:IsAbleToHand()
end
function c28316556.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316556.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c28316556.dcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.TossDice(tp,1)==6 and Duel.IsExistingMatchingCard(c28316556.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) then
		local ct=1
		if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 then ct=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c28316556.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,ct,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function c28316556.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if re:GetHandler():IsSetCard(0x289) and rp==tp and Duel.GetDiceResult()==3 and Duel.SelectYesNo(tp,aux.Stringid(28316556,2)) then
		Duel.Hint(HINT_CARD,0,28316556)
		Duel.SetDiceResult(6)
	end
end
