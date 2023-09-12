local m=53736007
local cm=_G["c"..m]
cm.name="摧心阵"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetValue(cm.zones)
	c:RegisterEffect(e1)
end
function cm.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local ft=0
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if p0 then ft=ft+1 end
	if p1 then ft=ft+1 end
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=not b and ft>0
	local b2=b and ft==1 and st-ft>0
	local b3=b and ft==2
	if b1 or b3 then return zone end
	if b2 and p0 then zone=zone-0x1 end
	if b2 and p1 then zone=zone-0x10 end
	return zone
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+Duel.GetCurrentPhase(),0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetReset(RESET_CHAIN)
	e1:SetLabelObject(e)
	e1:SetOperation(cm.regop)
	Duel.RegisterEffect(e1,tp)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() then Duel.ResetFlagEffect(tp,m) end
end
function cm.penfilter(c)
	return c:IsSetCard(0x5538) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ft=ft+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ft=ft+1 end
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=not b and ft>0
	local b2=b and ft==1 and st-ft>0
	local b3=b and ft==2
	if chk==0 then return (b1 or b2 or b3) and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK,0,1,nil) end
	local ph=Duel.GetCurrentPhase()
	if ph==PHASE_MAIN1 or ph==PHASE_MAIN2 then e:SetLabel(1) else e:SetLabel(0) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:GetLabel()==1 then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
