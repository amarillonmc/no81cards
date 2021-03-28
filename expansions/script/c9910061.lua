--回眸之月神
function c9910061.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910061)
	e1:SetCost(c9910061.cost)
	e1:SetTarget(c9910061.target)
	e1:SetOperation(c9910061.operation)
	c:RegisterEffect(e1)
	--return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCost(c9910061.thcost)
	e2:SetTarget(c9910061.thtg)
	e2:SetOperation(c9910061.thop)
	c:RegisterEffect(e2)
end
function c9910061.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910061.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c9910061.rmfilter(c)
	return c:IsSetCard(0x9951) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9910061.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local id=Duel.GetTurnCount()
	local res=tc:GetTurnID()==id and tc:GetPreviousControler()~=tp and tc:IsPreviousLocation(LOCATION_HAND)
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and res then
		local g=Duel.GetMatchingGroup(c9910061.rmfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910061,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c9910061.cfilter(c)
	return c:IsRace(RACE_FAIRY) and not c:IsPublic()
end
function c9910061.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910061.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9910061.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c9910061.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttackTarget()==c or (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil) end
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9910061.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local c=Duel.GetAttacker()
	if c:IsRelateToBattle() then g:AddCard(c) end
	c=Duel.GetAttackTarget()
	if c~=nil and c:IsRelateToBattle() then g:AddCard(c) end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
