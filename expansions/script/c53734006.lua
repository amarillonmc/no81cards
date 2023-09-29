local m=53734006
local cm=_G["c"..m]
cm.name="随青缀 藤村静"
cm.Snnm_Ef_Rst=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.discon1)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(cm.discon2)
	c:RegisterEffect(e2)
	if not cm.Aozora_Check then
		cm.Aozora_Check=true
		cm[0]=Duel.RegisterEffect
		Duel.RegisterEffect=function(e,p)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local pro,pro2=e:GetProperty()
				pro=pro|EFFECT_FLAG_PLAYER_TARGET
				e:SetProperty(pro,pro2)
				e:SetTargetRange(1,1)
			end
			cm[0](e,p)
		end
		cm[1]=Card.RegisterEffect
		Card.RegisterEffect=function(c,e,bool)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local op,range,con=e:GetOperation(),0,0
				if e:GetRange() then range=e:GetRange() end
				if e:GetCondition() then con=e:GetCondition() end
				if op then
					local ex=Effect.CreateEffect(c)
					ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					ex:SetCode(EVENT_ADJUST)
					ex:SetRange(range)
					ex:SetOperation(cm.exop)
					cm[1](c,ex)
					cm[ex]={op,range,con}
					e:SetOperation(nil)
				else
					local pro,pro2=e:GetProperty()
					pro=pro|EFFECT_FLAG_PLAYER_TARGET
					e:SetProperty(pro,pro2)
					e:SetTargetRange(1,1)
				end
			end
			cm[1](c,e,bool)
		end
	end
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 then return end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY,0,0)
	local op,range,con=cm[e][1],cm[e][2],cm[e][3]
	local val=op(e,tp)
	if tp==1 then val=((val&0xffff)<<16)|((val>>16)&0xffff) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	if range~=0 then e1:SetRange(range) end
	if con~=0 then e1:SetCondition(con) end
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY)
	c:RegisterEffect(e1)
end
function cm.discon1(e,tp,eg,ep,ev,re,r,rp)
	return SNNM.DisMZone(tp)&0x1f==0
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	return SNNM.DisMZone(tp)&0x1f>0
end
function cm.disfilter(c)
	return aux.NegateAnyFilter(c) and c:IsStatus(STATUS_EFFECT_ENABLED) and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=SNNM.RinnaZone(tp,Duel.GetMatchingGroup(function(c)return c:GetSequence()<5 and c:IsAbleToRemove()end,tp,LOCATION_MZONE,0,nil))>0 and Duel.IsExistingMatchingCard(cm.disfilter,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=SNNM.DisMZone(tp)&0x1f>0
	if chk==0 then return b1 or b2 end
	local zone=0
	if b1 then zone=zone|SNNM.RinnaZone(tp,Duel.GetMatchingGroup(function(c)return c:GetSequence()<5 and c:IsAbleToRemove()end,tp,LOCATION_MZONE,0,nil)) end
	if b2 then zone=zone|SNNM.DisMZone(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local dis=Duel.SelectField(tp,1,LOCATION_MZONE,0,(~zone)|0x60)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
	if SNNM.DisMZone(tp)&0x1f==0 then
		local rc=Duel.GetFieldCard(tp,LOCATION_MZONE,math.log(dis,2))
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,LOCATION_ONFIELD)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c,dis=e:GetHandler(),e:GetLabel()
	local zone=dis
	if dis&SNNM.DisMZone(tp)==0 then
		if tp==1 then dis=((dis&0xffff)<<16)|((dis>>16)&0xffff) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetValue(dis)
		Duel.RegisterEffect(e1,tp)
		local tc=Duel.GetMatchingGroup(function(c,zone)return (2^c:GetSequence())&zone~=0 end,tp,LOCATION_MZONE,0,nil,zone):GetFirst()
		if not tc then return end
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 and tc:IsLocation(LOCATION_REMOVED) then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_ADJUST)
			e2:SetLabel(zone)
			e2:SetLabelObject(tc)
			e2:SetCondition(cm.retcon)
			e2:SetOperation(cm.retop)
			Duel.RegisterEffect(e2,tp)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local ng=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #ng==0 then return end
			Duel.HintSelection(ng)
			local nc=ng:GetFirst()
			Duel.NegateRelatedChain(nc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e2)
		end
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabel(zone)
		e1:SetOperation(cm.regop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetLabel(zone)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.rstop)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc,dis=e:GetLabelObject(),e:GetLabel()
	if not tc or tc:GetFlagEffect(m)==0 then
		e:Reset()
		return false
	else return Duel.CheckLocation(tp,LOCATION_MZONE,math.log(dis,2)) end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc,tc:GetPreviousPosition(),e:GetLabel())
	e:Reset()
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local dis=e:GetLabel()
	if rp==tp or dis&SNNM.DisMZone(tp)==0 then return end
	Duel.Hint(HINT_CARD,0,m)
	SNNM.ReleaseMZone(e,tp,dis)
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local dis=e:GetLabel()
	if dis&SNNM.DisMZone(tp)>0 then return end
	e:GetLabelObject():Reset()
	e:Reset()
end
