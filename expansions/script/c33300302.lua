--虚网后台破坏者
local m=33300302
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.condition2)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.IsLinkZoneOver(count)
	local flag=0
	for i=0,4 do
		if (Duel.GetLinkedZone(0)&((2^i)<<0))~=0 then
			flag=flag+1
		elseif (Duel.GetLinkedZone(1)&((2^i)<<0))~=0 then
			flag=flag+1
		end
	end
	return flag>=count
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return cm.IsLinkZoneOver(3)
end
function cm.check(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsDestructable(e) end
	local g=Duel.GetMatchingGroup(cm.check,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.operation(e,tp)
	local sg=Duel.GetMatchingGroup(cm.check,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		if e:GetHandler():IsRelateToEffect(e) then
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.thcheck(c)
	return c:IsSetCard(0x562) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thcheck,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,cm.thcheck,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		if Duel.SendtoHand(sg,tp,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg)
			if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.tgcheck,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
				local tg=Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local rg=Duel.SelectMatchingCard(tp,cm.tgcheck,tp,LOCATION_REMOVED,0,1,1,nil)
				Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RETURN)
			end
		end
	end
end
function cm.tgcheck(c)
	return c:IsSetCard(0x562) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end