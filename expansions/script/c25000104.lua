local m=25000104
local cm=_G["c"..m]
cm.name="第三行星的奇迹"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.Third_Planet then
		cm.Third_Planet=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RECOVER)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,m,0,0,1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then
		e:Reset()
		return false
	else return true end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.tkop)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetFlagEffect(0,m+20000)>0 then return end
	Duel.RegisterFlagEffect(0,m+20000,0,0,0)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetTargetRange(0xff,0xff)
	e2:SetOperation(cm.costop)
	Duel.RegisterEffect(e2,tp)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m+10000,RESET_CHAIN,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(function(c)return c:IsFaceup() and c:IsCode(m+1)end,tp,LOCATION_MZONE,0,nil)>0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,10,RACE_FAIRY,ATTRIBUTE_LIGHT) or Duel.GetFlagEffect(0,m+10000)>0 then return end
	local tc=Duel.CreateToken(tp,m+1)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetLabelObject(tc)
	e0:SetTargetRange(1,0)
	e0:SetCondition(cm.econ)
	Duel.RegisterEffect(e0,tp)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetValue(function(e,re,ev,r,rp,rc)return bit.band(r,REASON_EFFECT)~=0 end)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetLabelObject(tc)
	e2:SetCondition(cm.econ)
	e2:SetOperation(cm.ceoperation)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.econ2)
	e3:SetOperation(cm.tgop)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetLabelObject(tc)
	e4:SetCondition(cm.atkcon)
	e4:SetTarget(function(e,c)return c==e:GetLabelObject()end)
	e4:SetValue(cm.atkval)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE)
	e5:SetValue(cm.defval)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD_P)
	e6:SetLabelObject(tc)
	e6:SetOperation(cm.rstop1)
	Duel.RegisterEffect(e6,tp)
	local e7=Effect.CreateEffect(e:GetHandler())
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CUSTOM+m)
	e7:SetLabelObject(e3)
	e7:SetOperation(cm.rstop2)
	Duel.RegisterEffect(e7,tp)
end
function cm.econ(e)
	local tc=e:GetLabelObject()
	if not tc or Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>0 then
		e:Reset()
		return false
	else return true end
end
function cm.econ2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetFlagEffect(tp,m)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==tp
end
function cm.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.Destroy(c,REASON_EFFECT) end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SendtoGrave(g,REASON_RULE)
end
function cm.atkcon(e)
	local tc=e:GetLabelObject()
	local ph=Duel.GetCurrentPhase()
	if not tc or Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>0 then
		e:Reset()
		return false
	else return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and tc:GetBattleTarget() end
end
function cm.atkval(e,c)
	local tc=e:GetLabelObject()
	local bc=tc:GetBattleTarget()
	if not bc then return false end
	local atk=bc:GetAttack()+100
	if bc:IsFacedown() then atk=100 end
	return atk
end
function cm.defval(e,c)
	local tc=e:GetLabelObject()
	local bc=tc:GetBattleTarget()
	if not bc then return false end
	local def=bc:GetDefense()+100
	if bc:IsFacedown() then def=100 end
	return def
end
function cm.rstop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not eg:IsContains(tc) then return end
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
	e:Reset()
end
function cm.rstop2(e,tp,eg,ep,ev,re,r,rp)
	local re=e:GetLabelObject()
	if re then re:Reset() end
	e:Reset()
end
