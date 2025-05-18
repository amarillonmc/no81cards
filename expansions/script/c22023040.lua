--人理保障？咕哒子
function c22023040.initial_effect(c)
	aux.EnableChangeCode(c,22020000,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023040,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22023040.cost)
	e2:SetTarget(c22023040.target)
	e2:SetOperation(c22023040.operation)
	c:RegisterEffect(e2)
	--tohand ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023040,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCost(c22023040.cost1)
	e3:SetCondition(c22023040.erescon)
	e3:SetTarget(c22023040.target)
	e3:SetOperation(c22023040.operation)
	c:RegisterEffect(e3)
end
c22023040.effect_with_master=true
function c22023040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22023040.filter(c)
	return c:IsSetCard(0x1ff1) and not c:IsCode(22020000) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or chk and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c22023040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(c22023040.filter,tp,LOCATION_DECK,0,1,nil,e,tp,res)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c22023040.operation(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c22023040.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,res):GetFirst()
	if tc then
		if res and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c22023040.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023040.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end