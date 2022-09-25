local m=15000121
local cm=_G["c"..m]
cm.name="林中鹿"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c,true)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(cm.atkcon)
	e1:SetTarget(cm.atktg)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function cm.atktg(e,c)
	return c==Duel.GetAttacker() and c:IsType(TYPE_PENDULUM)
end
function cm.atkval(e,c)
	local d=Duel.GetAttackTarget()
	if c:GetAttack()<d:GetAttack() then
		return 1000
	else return 0 end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.GetLocationCountFromEx(1-tp,1-tp,nil,TYPE_PENDULUM)>0 end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,Group.FromCards(e:GetHandler()),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end
function cm.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsCode(15000121)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsAbleToExtra() then return end
	if Duel.SendtoExtraP(e:GetHandler(),1-tp,REASON_EFFECT)~=0 and Duel.GetLocationCountFromEx(1-tp,1-tp,nil,e:GetHandler())>0 then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(cm.spfilter,1-tp,LOCATION_EXTRA,0,nil,e,1-tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local tc=g:Select(1-tp,1,1,nil):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP)~=0 then
			tc:RegisterFlagEffect(15000121,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabelObject(tc)
			e1:SetCondition(cm.descon)
			e1:SetOperation(cm.desop)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e3:SetValue(cm.fuslimit)
			tc:RegisterEffect(e3,true)
			local e4=e2:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e4,true)
			local e5=e2:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e5,true)
		end
	end
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(15000121)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end