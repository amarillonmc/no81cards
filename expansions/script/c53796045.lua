local m=53796045
local cm=_G["c"..m]
cm.name="长久拾遗"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil,tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil,tp,POS_FACEDOWN):GetFirst()
		if tc and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 and tc:IsCode(53799250,53799256,53799267,53796042,53796043,53796044,53796071) then
			local le={tc:GetActivateEffect()}
			for _,te in pairs(le) do
				local e1=te:Clone()
				e1:SetDescription(aux.Stringid(m,0))
				e1:SetRange(LOCATION_REMOVED)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(tc)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_ACTIVATE_COST)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetRange(LOCATION_REMOVED)
				e2:SetTargetRange(1,0)
				e2:SetLabelObject(e1)
				e2:SetTarget(function(e,te,tp)return te==e:GetLabelObject()end)
				e2:SetOperation(cm.costop)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
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
