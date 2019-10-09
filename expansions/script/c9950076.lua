--英灵召唤
function c9950076.initial_effect(c)
	--to hand or grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950076,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950076)
	e1:SetCost(c9950076.cost)
	e1:SetTarget(c9950076.target)
	e1:SetOperation(c9950076.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(9950076,2))
	e2:SetCost(c9950076.thcost)
	c:RegisterEffect(e2)
end
function c9950076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c9950076.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9950076.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba5) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c9950076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c9950076.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,ft,e,tp)
	end
end
function c9950076.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local g=Duel.SelectMatchingCard(tp,c9950076.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,ft,e,tp)
	if g:GetCount()>0 then
		local th=g:GetFirst():IsAbleToHand()
		local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,1190,1152)
		elseif th then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end