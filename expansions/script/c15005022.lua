local m=15005022
local cm=_G["c"..m]
cm.name="一心瞬影·天下人"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--SynchroSummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(aux.SynCondition(cm.c1filter,cm.c2filter,2,99))
	e0:SetTarget(aux.SynTarget(cm.c1filter,cm.c2filter,2,99))
	e0:SetOperation(cm.SynOperation(cm.c1filter,cm.c2filter,2,99))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.econ)
	e1:SetOperation(cm.eop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(cm.atk1op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.atk2op)
	c:RegisterEffect(e5)
	--Musou Shinsetsu
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,15005022)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCondition(cm.mscon)
	e6:SetTarget(cm.mstg)
	e6:SetOperation(cm.msop)
	c:RegisterEffect(e6)
end
function cm.c1filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER)
end
function cm.c2filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_THUNDER)
end
function cm.SynOperation(f1,f2,minct,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.Destroy(g,REASON_MATERIAL+REASON_SYNCHRO+REASON_REPLACE+REASON_EFFECT)
				--Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
function cm.valfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf41) and c:IsType(TYPE_SYNCHRO)
end
function cm.valcheck(e,c)
	local flag=0
	local g=c:GetMaterial()
	if g:GetCount()>0 then
		flag=1
	end
	if g:GetCount()>0 and g:IsExists(cm.valfilter,1,nil) then
		flag=2
	end
	e:GetLabelObject():SetLabel(flag)
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==2 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(cm.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.atk1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetAttack()<15000 and (not re:GetHandler():IsCode(15005022)) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xaf41) and c:GetFlagEffect(1)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function cm.atk2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetAttack()<15000 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function cm.mscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetAttack()>c:GetBaseAttack() and Duel.GetFlagEffect(tp,15005023)==0
end
function cm.desfilter(c,atk)
	return c:GetAttack()<=atk
end
function cm.mstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:GetAttack()<=c:GetBaseAttack() then return false end
		local atk=c:GetAttack()-c:GetBaseAttack()
		return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,atk)
	end
	local atk=c:GetAttack()-c:GetBaseAttack()
	if c:GetAttack()<=c:GetBaseAttack() then atk=c:GetBaseAttack()-c:GetAttack() end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.msop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()-c:GetBaseAttack()
	if c:GetAttack()<=c:GetBaseAttack() then atk=c:GetBaseAttack()-c:GetAttack() end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,atk)
	if g:GetCount()~=0 then
		Duel.Hint(HINT_CARD,1-tp,15005023)
		Duel.Hint(HINT_CARD,1-tp,15005024)
		Duel.Hint(HINT_CARD,1-tp,15005025)
		Duel.Hint(HINT_CARD,1-tp,15005026)
		Duel.Hint(HINT_CARD,1-tp,15005027)
		--Duel.Hint(HINT_CARD,1-tp,15005028)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(3000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
	Duel.RegisterFlagEffect(tp,15005023,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end