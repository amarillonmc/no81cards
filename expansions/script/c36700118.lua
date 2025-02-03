--释放你的想象力吧！
function c36700118.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c36700118.condition)
	e1:SetCost(c36700118.cost)
	e1:SetTarget(c36700118.target)
	e1:SetOperation(c36700118.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,36700118)
	e2:SetCost(c36700118.thcost)
	e2:SetTarget(c36700118.thtg)
	e2:SetOperation(c36700118.thop)
	c:RegisterEffect(e2)
end
function c36700118.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c36700118.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c36700118.spfilter(c,e,tp)
	return c:IsSetCard(0xc22) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c36700118.tgfilter(c)
	return c:IsSetCard(0xc22) and c:IsAbleToGrave()
end
function c36700118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(c36700118.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,e:GetHandler())
	local b1=Duel.IsExistingMatchingCard(c36700118.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
	local b2=tg:CheckSubGroup(aux.gfcheck,2,2,Card.IsLocation,LOCATION_HAND,LOCATION_DECK) and Duel.IsPlayerCanDraw(tp,2) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
	local b3=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0xc22)
	if chk==0 then return b1 or b2 or b3 end
end
function c36700118.activate(e,tp,eg,ep,ev,re,r,rp)
	--select
	local tg=Duel.GetMatchingGroup(c36700118.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,e:GetHandler())
	local b1=Duel.IsExistingMatchingCard(c36700118.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetMZoneCount(tp)>0
	local b2=tg:CheckSubGroup(aux.gfcheck,2,2,Card.IsLocation,LOCATION_HAND,LOCATION_DECK)
		and Duel.IsPlayerCanDraw(tp,2) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
	local b3=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0xc22)
	local op=aux.SelectFromOptions(tp,
		{b1,1152},
		{b2,1191},
		{b3,1190})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c36700118.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=tg:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsLocation,LOCATION_HAND,LOCATION_DECK)
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	elseif op==3 then
		Duel.Damage(1-tp,500,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0xc22)
		local dct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local seq=-1
		local hc
		for tc in aux.Next(g) do
			local sq=tc:GetSequence()
			if sq>seq then
				seq=sq
				hc=tc
			end
		end
		Duel.BreakEffect()
		if seq>-1 then
			Duel.ConfirmDecktop(tp,dct-seq)
			Duel.DisableShuffleCheck()
			if hc:IsAbleToHand() then
				Duel.SendtoHand(hc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hc)
				Duel.ShuffleHand(tp)
			else
				Duel.SendtoGrave(hc,REASON_RULE)
			end
		else
			Duel.ConfirmDecktop(tp,dct)
		end
		if dct-seq>1 then Duel.ShuffleDeck(tp) end
	end
end
function c36700118.costfilter(c)
	return c:IsSetCard(0xc22) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c36700118.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36700118.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c36700118.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c36700118.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c36700118.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
