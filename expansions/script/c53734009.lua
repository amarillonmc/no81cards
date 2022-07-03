local m=53734009
local cm=_G["c"..m]
cm.name="缘红缀 三田村茜"
cm.Snnm_Ef_Rst=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1,m+50)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
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
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.operation)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function cm.cfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x3536) and c:IsControler(tp) and c:GetSequence()<5
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and #g==1 and g:IsExists(cm.cfilter,1,nil,tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	return Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 and tc:IsLocation(LOCATION_REMOVED) then
			local dis=1<<tc:GetPreviousSequence()
			if dis&SNNM.DisMZone(tp)>0 then return end
			local zone=dis
			if tp==1 then dis=((dis&0xffff)<<16)|((dis>>16)&0xffff) end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetValue(dis)
			Duel.RegisterEffect(e1,tp)
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
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return tn~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return SNNM.DisMZone(tp)&0x1f>0 end
	local zone=SNNM.DisMZone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local z=Duel.SelectField(tp,1,LOCATION_MZONE,0,(~zone)|0xe000e0)
	Duel.Hint(HINT_ZONE,tp,z)
	e:SetLabel(z)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local z=e:GetLabel()
	local dis=SNNM.DisMZone(tp)
	if z==0 or z&dis==0 then return end
	SNNM.ReleaseMZone(e,tp,z)
end
