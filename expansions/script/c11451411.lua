--shrimp, patrol of dragon palace
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,m-10)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(0)
	e4:SetCondition(cm.condition0)
	c:RegisterEffect(e4)
	cm.hand_effect=cm.hand_effect or {}
	cm.hand_effect[c]=e1
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cm.condition2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.condition4)
	--e3:SetTarget(cm.target4)
	e3:SetOperation(cm.operation4)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e5)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and not e:GetHandler():IsPublic()
end
function cm.condition0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,11451425) and not e:GetHandler():IsPublic()
end
function cm.filter(c,tp)
	return c:IsSetCard(0x6978) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function cm.filter2(c)
	return c:IsSetCard(0x6978) and c:IsAbleToHand()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local c=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(c)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(c:GetProperty())
	local target=c:GetTarget()
	if target then target(e,tp,eg,ep,ev,re,r,rp,1) end
	if tp==Duel.GetTurnPlayer() and Duel.IsPlayerAffectedByEffect(tp,11451425) then Duel.IsPlayerAffectedByEffect(tp,11451425):GetHandler():RegisterFlagEffect(11451425,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if not c then return end
	local r=e:GetHandler():IsRelateToEffect(e)
	local operation=c:GetOperation()
	if operation then operation(e,tp,eg,ep,ev,re,r,rp) end
	if r and not e:GetHandler():IsLocation(LOCATION_GRAVE) and not e:GetHandler():IsLocation(LOCATION_REMOVED) then
		--Duel.BreakEffect()
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and Duel.GetCurrentChain()~=0
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	--0xc7a0000=RESET_MSCHANGE+RESET_OVERLAY+RESET_REMOVE+RESET_TEMP_REMOVE+RESET_TOHAND+RESET_TODECK+RESET_TURN_SET
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0xc7a0000+RESET_CHAIN,0,1)
end
function cm.condition4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0 and Duel.GetCurrentChain()==1
end
function cm.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x6978)
	if chk==0 then return g:GetCount()>0 end
end
function cm.operation4(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(m)
	--effect phase end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.condition3)
	e3:SetOperation(cm.operation3)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	return count~=0 and g:GetCount()~=0
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local count=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=g:SelectSubGroup(tp,aux.dncheck,false,1,count)
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,hg)
end