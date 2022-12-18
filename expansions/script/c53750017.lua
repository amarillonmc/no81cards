local m=53750017
local cm=_G["c"..m]
cm.name="异律次元残片"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(cm.condition2)
	e2:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetTargetRange(1,1)
	e3:SetLabelObject(e2)
	e3:SetTarget(function(e,te,tp)return te==e:GetLabelObject()end)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(cm.setcon)
	e4:SetTarget(cm.settg)
	e4:SetOperation(cm.setop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.filter(c,re)
	return c:GetType()==TYPE_SPELL and c:IsReason(REASON_COST) and re
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.filter,1,nil,re) then Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1) end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0 and Duel.GetFlagEffect(0,m)>0
end
function cm.thfilter(c,cl)
	if cl<2 or cl>3 then return false end
	return c:IsAbleToHand() and ((cl==2 and c:IsSetCard(0x9532) and c:IsType(TYPE_SPELL)) or (cl==3 and c:IsRace(RACE_REPTILE)))
end
function cm.rmfilter(c,cl)
	if cl<4 then return false end
	return aux.NegateAnyFilter(c) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cl=Duel.GetCurrentChain()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,cl+1) or Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,cl+1) end
	local cat=0
	if cl>1 and cl<4 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if cl>3 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local cl=Duel.GetCurrentChain()
	local g1=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,cl)
	local g2=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,cl)
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	if #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.cfilter(c,tp,rp)
	return c:GetPreviousControler()==tp and rp==1-tp and c:IsReason(REASON_EFFECT)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,rp)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabelObject(te)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re==e:GetLabelObject() end)
	e1:SetOperation(cm.ready)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetOperation(cm.rsop)
	Duel.RegisterEffect(e2,tp)
end
function cm.ready(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetHandler():SetStatus(STATUS_EFFECT_ENABLED,true)
	e:Reset()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetHandler():SetStatus(STATUS_ACTIVATE_DISABLED,true)
	e:Reset()
end
