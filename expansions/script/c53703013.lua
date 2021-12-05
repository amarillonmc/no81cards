local m=53703013
local cm=_G["c"..m]
cm.name="布莱克指令"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_PENDULUM)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsOnField() and e:GetHandler():IsAbleToRemoveAsCost() and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_PENDULUM)
end
function cm.filter1(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsSetCard(0x3533)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_PZONE) and Duel.GetMZoneCount(tp,e:GetHandler())>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0)
end
function cm.filter2(c)
	return c:IsSetCard(0x3533) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_PZONE+LOCATION_EXTRA,0,nil,e,tp)
	local b2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #b1>0 or #b2>0 end
	local off=1
	local ops={}
	local opval={}
	if #b1>0 then
		ops[off]=aux.Stringid(m,1)
		opval[off]=0
		off=off+1
	end
	if #b2>0 then
		ops[off]=aux.Stringid(m,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,sel+1))
	if sel==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE+LOCATION_EXTRA)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local c=e:GetHandler()
	local b1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_PZONE+LOCATION_EXTRA,0,nil,e,tp)
	local b2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=b1:Select(tp,1,1,nil):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(m)>0 then
			tc:RegisterFlagEffect(m,0,0,0)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetLabelObject(tc)
			e2:SetCondition(cm.regcon1)
			e2:SetOperation(cm.regop)
			Duel.RegisterEffect(e2,tp)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=b2:Select(tp,1,1,nil):GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 and c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(m)>0 then
			tc:RegisterFlagEffect(m,0,0,0)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_SPSUMMON_SUCCESS)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetLabelObject(tc)
			e3:SetCondition(cm.regcon2)
			e3:SetOperation(cm.regop)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function cm.cfilter1(c,tc)
	return c==tc and c:IsReason(REASON_EFFECT) and c:GetFlagEffect(m)>0
end
function cm.regcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsExists(cm.cfilter1,1,nil,tc) and e:GetHandler():GetFlagEffect(m)>0
end
function cm.cfilter2(c,tc)
	return c==tc and c:GetFlagEffect(m)>0
end
function cm.regcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsExists(cm.cfilter2,1,nil,tc) and e:GetHandler():GetFlagEffect(m)>0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and c:GetFlagEffect(m)>0 then
		Duel.Hint(HINT_CARD,0,m)
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(cm.thcon)
		e1:SetOperation(cm.thop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
			c:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2,fid)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
			c:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
		end
		Duel.RegisterEffect(e1,tp)
	end
	e:Reset()
	tc:ResetFlagEffect(m)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetValue()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c and c:GetFlagEffectLabel(m+50)==e:GetLabel() then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
