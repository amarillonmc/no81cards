--瑞佳 永恒之扉
local m=33701455
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.valcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	e2:SetLabelObject(e1) 
	c:RegisterEffect(e2)
end
--Effect 1
function cm.valcheck(e,c)
	local g=c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_TOKEN)
	e:SetLabel(g)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
		and e:GetLabelObject():GetLabel()~=0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local vt=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	c:RegisterFlagEffect(m+m*2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,vt-1))
	if vt>=1 then
		local e02=Effect.CreateEffect(c)
		e02:SetType(EFFECT_TYPE_SINGLE)
		e02:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e02:SetValue(cm.indes)
		e02:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e02)
	end
	if  vt>=2 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(cm.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
	if vt>=3 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,4))
		e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetTarget(cm.rntg)
		e1:SetOperation(cm.rnop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)	
	end
	if vt>=4 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,1)
		e3:SetTarget(cm.sumlimit)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)	
	end
end
function cm.indes(e,c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsType(TYPE_TOKEN)
end
function cm.rf(c)
	return c:IsType(TYPE_MONSTER)
		and c:IsAbleToRemove()
		and (c:GetAttack()>0 or c:GetDefense()>0)   
end
function cm.rntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.rf,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	if chk==0 then return #g1>0 and #g2>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
end
function cm.rnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.rf),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g1:Select(tp,1,1,nil)
	local rc=rg:GetFirst()
	Duel.HintSelection(rg)
	if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0
		and rc:IsLocation(LOCATION_REMOVED)
		and #g2>0 then
		local atk=rc:GetAttack()
		local def=rc:GetDefense()
		if atk>0 or def>0 then
			local tc=g2:GetFirst()
			while tc do   
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetValue(def)
				tc:RegisterEffect(e2)
				tc=g2:GetNext()
			end 
		end
	end
end
