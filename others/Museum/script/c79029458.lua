--红豆·音律联觉收藏-漆黑热浪
function c79029458.initial_effect(c)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(79029012)
	c:RegisterEffect(e0) 
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,79029458)
	e1:SetCost(c79029458.thcost)
	e1:SetTarget(c79029458.thtg)
	e1:SetOperation(c79029458.thop)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,09029458)
	e2:SetTarget(c79029458.thtg1)
	e2:SetOperation(c79029458.thop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)   
end
function c79029458.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c79029458.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c79029458.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c79029458.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c79029458.thfilter(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79029458.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029458.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029458.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("各位，请做好出发准备，也请多多配合我！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029458,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029458.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79029458.xfil(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xa900) and Duel.IsPlayerCanDiscardDeck(tp,c:GetLink())
end
function c79029458.thfilter1(c)
	return (c:IsSetCard(0xb90d) or c:IsSetCard(0xc90e)) and c:IsAbleToHand()
end
function c79029458.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029458.xfil,tp,LOCATION_EXTRA,0,3,nil) end
end
function c79029458.thop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029458.xfil,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()<3 then return end
	Debug.Message("我血液在沸腾！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029458,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local sg=g:Select(tp,3,3,nil)
	Duel.ConfirmCards(1-tp,sg)
	local tc=sg:RandomSelect(1-tp,1):GetFirst()
	local x=tc:GetLink()
	Duel.ConfirmCards(tp,tc)
	if Duel.IsPlayerCanDiscardDeck(tp,x) then
		Duel.ConfirmDecktop(tp,x)
		local g=Duel.GetDecktopGroup(tp,x)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(c79029458.thfilter1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029458,0)) then
			Debug.Message("不会输给你的！")
			Duel.Hint(HINT_SOUND,0,aux.Stringid(79029458,3))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c79029458.thfilter1,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		end
	end
end

















