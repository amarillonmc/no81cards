--神世界的探索者
local s,id=GetID()

function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_DISABLE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end

function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function s.gw_filter(c)
	return c:IsFaceup() and s.Grandwalker(c) and c:IsType(TYPE_PENDULUM)
end

function s.thfilter(c, race, attr)
	return c:IsType(TYPE_MONSTER) and c:IsRace(race) and c:IsAttribute(attr) and c:IsAbleToHand()
end

function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
		local g=Duel.GetMatchingGroup(s.gw_filter,tp,LOCATION_PZONE+LOCATION_EXTRA,0,nil)
		for tc in aux.Next(g) do
			local b1 = tc:IsAbleToHand() and Duel.IsChainDisablable(ev)
			local b2 = Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetOriginalRace(),tc:GetOriginalAttribute())
			if b1 or b2 then return true end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_PZONE+LOCATION_EXTRA+LOCATION_DECK)
	if Duel.IsChainDisablable(ev) then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	end
end

function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(s.gw_filter,tp,LOCATION_PZONE+LOCATION_EXTRA,0,nil)
		local valid_g=Group.CreateGroup()
		for tc in aux.Next(g) do
			local b1 = tc:IsAbleToHand() and Duel.IsChainDisablable(ev)
			local b2 = Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetOriginalRace(),tc:GetOriginalAttribute())
			if b1 or b2 then
				valid_g:AddCard(tc)
			end
		end
		if #valid_g>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=valid_g:Select(tp,1,1,nil):GetFirst()
			local b1 = tc:IsAbleToHand() and Duel.IsChainDisablable(ev)
			local b2 = Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetOriginalRace(),tc:GetOriginalAttribute())
			
			local op=0
			if b1 and b2 then
				op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3)) 
			elseif b1 then
				op=Duel.SelectOption(tp,aux.Stringid(id,2))
			else
				op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
			end
			
			if op==0 then
				if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
					Duel.NegateEffect(ev)
				end
			else
				local race=tc:GetOriginalRace()
				local attr=tc:GetOriginalAttribute()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,race,attr)
				if #sg>0 then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
				end
			end
		end
	end
end

function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.gw_filter,tp,LOCATION_PZONE+LOCATION_EXTRA,0,nil)
	return g:GetClassCount(Card.GetCode)>=2
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK) then
		if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
