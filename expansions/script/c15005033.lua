local m=15005033
local cm=_G["c"..m]
cm.name="秉烛瞬影·迅捷剑"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--SynchroSummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(aux.SynCondition(nil,aux.NonTuner(nil),1,99))
	e0:SetTarget(aux.SynTarget(nil,aux.NonTuner(nil),1,99))
	e0:SetOperation(cm.SynOperation(nil,aux.NonTuner(nil),1,99))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	--add check
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(cm.tncon)
	e8:SetOperation(cm.tnop)
	c:RegisterEffect(e8)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e8)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.ncon)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(cm.ycon)
	c:RegisterEffect(e4)
	--extra attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.n2con)
	e5:SetValue(cm.exatkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCondition(cm.y2con)
	c:RegisterEffect(e6)
	--RemoveCounter
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,2))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(cm.rctcon)
	e7:SetOperation(cm.rctop)
	c:RegisterEffect(e7)
	--
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.counter_add_list={0x1f36}
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Card.RegisterFlagEffect(Duel.GetAttacker(),15005034,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.SynOperation(f1,f2,minct,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.Destroy(g,REASON_MATERIAL+REASON_SYNCHRO+REASON_REPLACE+REASON_EFFECT+REASON_RULE)
				--Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x1f36,1) end
end
function cm.ctfilter(c,tp)
	return c:GetCounter(0x1f36)>0 and c:IsCanRemoveCounter(tp,0x1f36,c:GetCounter(0x1f36),REASON_EFFECT)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if c:AddCounter(0x1f36,1) and Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_ONFIELD,0,1,c,tp) then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(cm.ctfilter,tp,LOCATION_ONFIELD,0,c,tp)
			local tc=g:GetFirst()
			local ct=0
			while tc do
				local ct1=tc:GetCounter(0x1f36)
				if tc:RemoveCounter(tp,0x1f36,ct1,REASON_EFFECT) then
					ct=ct+ct1
				end
				tc=g:GetNext()
			end
			c:AddCounter(0x1f36,ct)
		end
	end
end
function cm.mfilter(c)
	return c:IsCode(15005004) or aux.IsCounterAdded(c,0x1f36)
end
function cm.valcheck(e,c)
	local flag=0
	local g=c:GetMaterial()
	if g:GetCount()>0 then
		flag=flag|1
	end
	if g:GetCount()>0 and g:IsExists(cm.mfilter,1,nil) then
		flag=flag|2
	end
	e:GetLabelObject():SetLabel(flag)
end
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()&2==2 then
		c:RegisterFlagEffect(15005033,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.ncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(15005033)==0
end
function cm.ycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(15005033)>0
end
function cm.atkval(e,c)
	return e:GetHandler():GetCounter(0x1f36)*300
end
function cm.n2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(15005033)==0 and c:GetCounter(0x1f36)>0
end
function cm.y2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(15005033)>0 and c:GetCounter(0x1f36)>0
end
function cm.exatkval(e)
	local c=e:GetHandler()
	return c:GetCounter(0x1f36)-1
end
function cm.rctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.rctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(15005034)
	local ct1=c:GetCounter(0x1f36)
	if ct1<ct then ct=ct1 end
	if ct==0 then return end
	if c:IsRelateToEffect(e) then
		c:RemoveCounter(tp,0x1f36,ct,REASON_EFFECT)
	end
end