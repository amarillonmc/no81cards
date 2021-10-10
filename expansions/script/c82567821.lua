--苏醒与启程
function c82567821.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82567821)
	e1:SetCost(c82567821.cost)
	e1:SetCondition(c82567821.condition)
	e1:SetTarget(c82567821.target)
	e1:SetOperation(c82567821.activate)
	c:RegisterEffect(e1)
	--AddCounter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,82567921)
	e2:SetTarget(c82567821.cttg)
	e2:SetOperation(c82567821.ctop)
	c:RegisterEffect(e2)
end
function c82567821.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c82567821.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==0
end
function c82567821.thfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and 
		Duel.IsExistingMatchingCard(c82567821.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode(),c:GetLeftScale())
end
function c82567821.thfilter2(c,code,scale)
	return c:IsSetCard(0x825) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and not c:IsCode(code) and not (c:GetLeftScale()-scale>8) and not (scale-c:GetLeftScale()>8)
end
function c82567821.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c82567821.thfilter,tp,LOCATION_DECK,0,nil)  
	return g:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c82567821.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c82567821.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,1)
	if g1:GetCount()>0 then
	local tc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c82567821.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),tc:GetLeftScale())
	if g2:GetCount()>0 then
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
	end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82567821.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c82567821.splimit(e,c)
	return not (c:IsSetCard(0x825) or c:IsSetCard(0x828)) and c:IsLocation(LOCATION_EXTRA)
end
function c82567821.tkfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567821.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and (chkc:IsLocation(LOCATION_MZONE) or chkc:IsLocation(LOCATION_PZONE)) and chkc:IsCanAddCounter(0x5825,2) and chkc:IsType(TYPE_PENDULUM) and chkc:IsSetCard(0x825) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567821.tkfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil,0x5825,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567821.tkfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil,0x5825,2)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,2)
end
function c82567821.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsSetCard(0x825) and tc:IsType(TYPE_PENDULUM)
  then  tc:AddCounter(0x5825,2)
	end
end