--希德小队静听聆音
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	c:EnableCounterPermit(0x61e)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.counter)
	c:RegisterEffect(e3)
	--atkdown
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.atkcon)
	e4:SetTarget(cm.atktg)
	e4:SetOperation(cm.atkop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	e4:SetLabelObject(e0)
	c:RegisterEffect(e5)
end
function cm.thfilter(c)
	return c:IsSetCard(0x61e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.BreakEffect()
			e:GetHandler():AddCounter(0x61e,3)
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0x61c) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function cm.condition(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cm.counter(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp and re:GetHandler():IsSetCard(0x61c) then
		e:GetHandler():AddCounter(0x61e,1)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x61e)
	e:SetLabel(ct)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	e:SetLabel(ct)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and ct>0
end
function cm.atkfilter(c,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP)
end
function cm.atfilter(c)
	return c:IsFaceup() and not c:IsAttack(0)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.atfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.atfilter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		local atkd=e:GetLabel()*300
		local dg=Group.CreateGroup()
		for sc in aux.Next(g) do
			local patk=sc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-atkd)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			if patk~=0 and sc:IsAttack(0) then dg:AddCard(sc) end
		end
		if #dg>0 then
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end