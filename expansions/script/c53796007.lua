local m=53796007
local cm=_G["c"..m]
cm.name="一览无余"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(function(e)return Duel.GetCurrentPhase()==PHASE_STANDBY end)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:GetLevel()>Duel.GetFlagEffect(0,m)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.ConfirmCards(1-tp,tc)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(66)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetLabelObject(tc)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.sp)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.sp(e,tp,eg,ep,ev,re,r,rp)
	local re=e:GetLabelObject()
	if not re then return end
	local tc=re:GetLabelObject()
	if not tc or Duel.GetMZoneCount(tp)==0 or tc:GetLevel()~=Duel.GetFlagEffect(0,m) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	e:Reset()
end
