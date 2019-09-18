--花之宫瑞穗
function c9910054.initial_effect(c)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910054,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910054)
	e1:SetCost(c9910054.cost)
	e1:SetTarget(c9910054.target)
	e1:SetOperation(c9910054.operation)
	c:RegisterEffect(e1)
	--return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910054,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c9910054.rthtarget)
	e2:SetOperation(c9910054.rthoperation)
	c:RegisterEffect(e2)
end
function c9910054.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910054.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c9910054.rmfilter(c)
	return c:IsCode(9910052) and c:IsAbleToRemove()
end
function c9910054.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c9910054.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c9910054.rmfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(c9910054.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9910054.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetChainLimit(c9910054.limit(g:GetFirst()))
end
function c9910054.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910054.rmfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=1 then return end
		if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end
function c9910054.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c9910054.rthtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttackTarget()==c or (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil) end
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c9910054.rthoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local c=Duel.GetAttacker()
	if c:IsRelateToBattle() then g:AddCard(c) end
	c=Duel.GetAttackTarget()
	if c~=nil and c:IsRelateToBattle() then g:AddCard(c) end
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=2 then return end
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
