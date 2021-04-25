local m=15000602
local cm=_G["c"..m]
cm.name="幻智指令·爆破回收"
function cm.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--when to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetReasonEffect():GetHandler():IsCode(15000624)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
	end
end
function cm.handcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,6000)/1000)
	local t={}
	for i=1,m do
		t[i]=i*1000
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	local lp1=Duel.GetLP(tp)
	Duel.PayLPCost(tp,ac)
	local lp2=Duel.GetLP(tp)
	local x=lp1-lp2
	e:SetLabel(x)
end
function cm.atfilter(c)
	return c:IsFaceup() and c:GetAttackAnnouncedCount()<1 and c:IsSetCard(0xf36)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.atfilter,tp,LOCATION_MZONE,0,1,nil) and ((Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) or Duel.IsAbleToEnterBP()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.atfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.rtfilter(c)
	return c:IsSetCard(0xf36) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local tc=Duel.GetFirstTarget()
	local x=e:GetLabel()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetCondition(cm.anncon)
		e1:SetOperation(cm.annop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(x)
		e1:SetLabelObject(tc)
		e1:SetOwnerPlayer(tp)
		Duel.RegisterEffect(e1,tp)
		if c:IsStatus(STATUS_ACT_FROM_HAND) and Duel.IsExistingMatchingCard(cm.rtfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,cm.rtfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()~=0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetTargetRange(1,0)
	e3:SetValue(cm.damval2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetOwnerPlayer(tp)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetCondition(cm.damcon)
	Duel.RegisterEffect(e4,tp)
	end
end
function cm.damval2(e,re,val,r,rp,rc)
	local tp=e:GetOwnerPlayer()
	if bit.band(r,REASON_EFFECT)~=0 and Duel.GetFlagEffect(tp,15000600)==0 then
		Duel.RegisterFlagEffect(tp,15000600,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
function cm.damcon(e)
	local tp=e:GetOwnerPlayer()
	return Duel.GetFlagEffect(tp,15000600)==0
end
function cm.anncon(e,tp,eg,ep,ev,re,r,rp)
	local anc=Duel.GetAttacker()
	local antc=Duel.GetAttackTarget()
	local tc=e:GetLabelObject()
	local tp=e:GetOwnerPlayer()
	return anc and antc and ((anc:GetControler()==tp and anc:IsCode(tc:GetCode())) or (antc:GetControler()==tp and antc:IsCode(tc:GetCode()))) and Duel.GetFlagEffect(tp,15000602)==0
end
function cm.annop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetOwnerPlayer()
	local c=Duel.GetAttacker()
	if c:IsControler(1-tp) then c=Duel.GetAttackTarget() end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.RegisterFlagEffect(tp,15000602,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetOwner())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(e:GetLabel())
		c:RegisterEffect(e1)
	end
end