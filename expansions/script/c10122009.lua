--空想的湮灭
function c10122009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10122009,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c10122009.cost)
	e1:SetCondition(c10122009.condition)
	e1:SetTarget(c10122009.target)
	e1:SetOperation(c10122009.activate)
	c:RegisterEffect(e1) 
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122009,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c10122009.rmtg)
	e2:SetOperation(c10122009.rmop)
	c:RegisterEffect(e2)
end
function c10122009.rmfilter(c)
	return c:IsCode(10122011) and c:IsAbleToRemove()
end
function c10122009.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10122009.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10122009.rmfilter,tp,LOCATION_ONFIELD,0,5,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10122009.rmfilter,tp,LOCATION_ONFIELD,0,5,5,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c10122009.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if not g or g:FilterCount(Card.IsRelateToEffect,nil,e)~=5 or g2:GetCount()<=0 then return end
	g:Merge(g2)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c10122009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10122009.cfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=3 end
	local tg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			tg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.SendtoGrave(tg,REASON_COST)
end
function c10122009.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c10122009.cfilter(c)
	return c:IsSetCard(0xc333) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_FIELD)
end
function c10122009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsPlayerCanDraw(tp,1) end
end
function c10122009.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c10122009.repop)
end
function c10122009.acfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true) and c:IsSetCard(0xc333)
end
function c10122009.thfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand() and c:IsSetCard(0xc333) 
end
function c10122009.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)<=0 and Duel.Draw(1-tp,1,REASON_EFFECT)<=0 then return end
	local g=Duel.GetMatchingGroup(c10122009.acfilter,tp,0,LOCATION_HAND,nil,tp)
	if g:GetCount()<=0 or Duel.SelectYesNo(1-tp,aux.Stringid(10122009,2)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10122009,3))
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc then
	   Duel.SendtoGrave(fc,REASON_RULE)
	   Duel.BreakEffect()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
end
