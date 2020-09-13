--操魂师 凯萨拉
function c46270004.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfc1),4,2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46270004,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,46270004)
	e2:SetCost(c46270004.cost)
	e2:SetTarget(c46270004.destg)
	e2:SetOperation(c46270004.desop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46270004,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,146270004)
	e1:SetTarget(c46270004.drtg)
	e1:SetOperation(c46270004.drop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(46270004,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,246270004)
	e4:SetCost(c46270004.spcost)
	e4:SetTarget(c46270004.sptg)
	e4:SetOperation(c46270004.spop)
	c:RegisterEffect(e4)
end
function c46270004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c46270004.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c46270004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_DECK)
end
function c46270004.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local ct=math.min(Duel.Destroy(g,REASON_EFFECT),Duel.GetLocationCount(1-tp,LOCATION_MZONE))
	if ct>0 then
		Duel.BreakEffect()
		local tg=Duel.GetMatchingGroup(c46270004.filter,tp,0,LOCATION_DECK,nil,e,1-tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local tg1=tg:Select(1-tp,ct,ct,nil)
		if not tg1 then return end
		for tc in aux.Next(tg1) do
			Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetValue(0)
			tc:RegisterEffect(e3)
		end
		Duel.SpecialSummonComplete()
		if tg1:GetCount()<ct then
			Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_DECK))
			Duel.ShuffleDeck(1-tp)
		end
	end
end
function c46270004.drfilter(c)
	return c:IsFaceup() and c:GetAttack()==0
end
function c46270004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local n=Duel.GetMatchingGroupCount(c46270004.drfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return n>0 and Duel.IsPlayerCanDraw(tp,n) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,n)
end
function c46270004.drop(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetMatchingGroupCount(c46270004.drfilter,tp,0,LOCATION_MZONE,nil)
	if Duel.Draw(tp,n,REASON_EFFECT)==n then
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT,nil)
	end
end
function c46270004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c46270004.spfilter(c)
	return c:IsSetCard(0xfc1) and bit.band(c:GetType(),0x20004)==0x20004
end
function c46270004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local n=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c46270004.spfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c46270004.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c46270004.spfilter,tp,LOCATION_GRAVE,0,1,math.min(2,n),nil)
end
function c46270004.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not g then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		g=g:Select(tp,ft,ft,nil)
	end
	for tc in aux.Next(g) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
