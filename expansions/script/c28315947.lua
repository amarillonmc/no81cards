	--闪耀的萤火 樋口円香
function c28315947.initial_effect(c)
	aux.AddCodeList(c,28316050)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315947,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28315947)
	e1:SetCondition(c28315947.spcon)
	e1:SetTarget(c28315947.sptg)
	e1:SetOperation(c28315947.spop)
	c:RegisterEffect(e1)
	--noctchill dice
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetProperty(EFFECT_FLAG_DICE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38315947)
	e2:SetTarget(c28315947.dctg)
	e2:SetOperation(c28315947.dcop)
	c:RegisterEffect(e2)
	--noctchill dice change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TOSS_DICE_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c28315947.diceop)
	c:RegisterEffect(e3)
--c28315947.toss_dice=true
end
function c28315947.cfilter(c)
	return c:IsCode(28316050) and c:IsFaceup()
end
function c28315947.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28315947.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c28315947.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28315947.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28315947.thfilter(c)
	return (c:IsSetCard(0x289) or c:IsSetCard(0x286) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c28315947.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315947.pfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c28315947.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c28315947.pfilter(c)
	return c:IsCode(28346765) and c:IsAbleToGrave()
end
function c28315947.dcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.TossDice(tp,1)==6 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_LINK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_LINK)
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28315947.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c28315947.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if re:GetHandler():IsSetCard(0x289) and rp==tp and Duel.GetDiceResult()==4 and Duel.SelectYesNo(tp,aux.Stringid(28315947,2)) then
		Duel.Hint(HINT_CARD,0,28315947)
		Duel.SetDiceResult(6)
	end
end
