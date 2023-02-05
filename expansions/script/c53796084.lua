local m=53796084
local cm=_G["c"..m]
cm.name="牙琉雾人"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.negcon)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.tdcon)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if not (p==tp and loc==LOCATION_MZONE and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:GetHandler():IsLocation(LOCATION_MZONE) and g and g:IsExists(Card.IsControler,1,nil,1-tp) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.check(tp,re) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and e:GetHandler():IsAbleToRemove() end
	re:GetHandler():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not Duel.NegateActivation(ev) or not tc:IsRelateToEffect(e) or not cm.check(tp,re) or Duel.GetLocationCount(1-tp,LOCATION_SZONE)<1 then return end
	local c=e:GetHandler()
	if Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true) and tc:IsLocation(LOCATION_SZONE) then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_TRAP)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_HANDES)
		e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTarget(cm.target)
		e2:SetOperation(cm.activate)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		e3:SetLabelObject(tc)
		e3:SetTarget(cm.infilter)
		e3:SetValue(1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,1-tp,1-tp,0)
		if c:IsAbleToRemove() and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then
			c:SetTurnCounter(0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,7)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.turncon)
			e1:SetOperation(cm.turnop)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e2:SetCondition(cm.retcon)
			e2:SetOperation(cm.retop)
			Duel.RegisterEffect(e2,tp)
			c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_STANDBY,0,7)
			local mt=_G["c"..c:GetCode()]
			mt[c]=e1
		end
	end
end
function cm.infilter(e,c)
	local tc=e:GetLabelObject()
	if not tc:IsLocation(LOCATION_SZONE) or tc:IsFaceup() then e:Reset() end
	return c:IsFacedown() and tc==c
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
function cm.turncon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(1082946)~=0
end
function cm.turnop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()
	ct=ct+1
	tc:SetTurnCounter(ct)
	if ct>7 then
		tc:ResetFlagEffect(1082946)
		e:Reset()
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()
	if ct==7 then
		return true
	end
	if ct>7 then
		e:Reset()
	end
	return false
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_REMOVED) and re:GetHandler()==c and bit.band(r,REASON_EFFECT)~=0 then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0) end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetFlagEffect(m)~=0
end
function cm.tdfilter(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsStatus(STATUS_EFFECT_ENABLED) and not c:IsStatus(STATUS_LEAVE_CONFIRMED))
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(1-tp,cm.tdfilter,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then Duel.SendtoDeck(g,nil,2,REASON_RULE) end
end
function cm.check(tp,re)
	local rc=re:GetHandler()
	if rc:IsForbidden() then return false end
	local e1=Effect.CreateEffect(rc)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(TYPE_TRAP)
	rc:RegisterEffect(e1)
	local le1={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SSET)}
	local res=true
	for _,v in pairs(le1) do
		local val=v:GetValue()
		if not val or val(v,rc,1-tp) then
			res=false
			break
		end
	end
	if not res then return false end
	local le2={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_MAX_SZONE)}
	for _,v in pairs(le2) do
		local val=v:GetValue()
		if not val or val(v,1-tp,1-tp,LOCATION_REASON_TOFIELD) then
			res=false
			break
		end
	end
	e1:Reset()
	return res
end
