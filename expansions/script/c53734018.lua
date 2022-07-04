local m=53734018
local cm=_G["c"..m]
cm.name="在这片青空下约定"
cm.Snnm_Ef_Rst=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(cm.tdcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
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
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return SNNM.RinnaZone(tp,Duel.GetMatchingGroup(function(c)return c:GetSequence()<5 and c:IsAbleToRemove()end,tp,LOCATION_MZONE,0,nil))>0 end
	local fdzone=SNNM.RinnaZone(tp,Duel.GetMatchingGroup(function(c)return c:GetSequence()<5 and c:IsAbleToRemove()end,tp,LOCATION_MZONE,0,nil))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local dis=Duel.SelectField(tp,1,LOCATION_MZONE,0,(~fdzone)|0x60)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	local rc=Duel.GetFieldCard(tp,LOCATION_MZONE,math.log(dis,2))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c,dis=e:GetHandler(),e:GetLabel()
	if Duel.Damage(1-tp,700,REASON_EFFECT)~=0 and dis&SNNM.DisMZone(tp)==0 then
		local zone=dis
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
		end
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
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:IsFaceup() and c:IsSetCard(0x3536)end,tp,LOCATION_REMOVED,0,nil)
	if #g==0 then return false end
	local ct=g:GetClassCount(Card.GetCode)
	return ct==7 and SNNM.DisMZone(tp)&0x1f==0x1f
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local z=0
		for i=0,4 do if (1<<i)&SNNM.DisMZone(tp)>0 then z=z|(1<<i) end end
		if z==0 then return end
		Duel.BreakEffect()
		SNNM.ReleaseMZone(e,tp,z)
	end
end
