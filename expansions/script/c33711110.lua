--临终幻象
local m=33711110
local cm=_G["c"..m]
function c33711110.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SPSUMMON,TIMING_BATTLE_START)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		cm[2]=0
		cm[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		cm[ep]=cm[ep]+ev
		cm[ep+2]=cm[ep+2]+ev
	else
		cm[ep+2]=cm[ep+2]+ev
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
	cm[2]=0
	cm[3]=0
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and cm[tp]>0
end
function cm.spfilter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and g:CheckSubGroup(cm.subfilter,1,3,c) and c:IsAttackBelow(cm[tp])
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		local vg=g:SelectSubGroup(tp,cm.subfilter,true,1,3,tc)
		Duel.SendtoGrave(vg,REASON_EFFECT)
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_DISABLE)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_1)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_DISABLE_EFFECT)
		e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2_1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(cm.relcon)
		e2:SetOperation(cm.relop)
		Duel.RegisterEffect(e2,tp)
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.SpecialSummonComplete()
	end
end
function cm.relcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function cm.relop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 and tc:IsReleasable() then
		Duel.Release(tc,REASON_EFFECT)
		Duel.Recover(tp,tc:GetDefense(),REASON_EFFECT)
	else
		Duel.Damage(tp,cm[tp+2],REASON_EFFECT)
	end
	e:Reset()
end
function cm.synfilter(g,c)
	return c:IsSynchroSummonable(nil,g,g:GetCount(),g:GetCount())
end
function cm.xyzfilter(g,c)
	return c:IsXyzSummonable(g,g:GetCount(),g:GetCount())
end
function cm.fusfilter(g,c)
	local res=c:CheckFusionMaterial(g,nil,PLAYER_NONE)
	return res
end
function cm.linkfilter(g,c)
	return c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function cm.subfilter(g,c)
	return cm.synfilter(g,c) or cm.xyzfilter(g,c) or cm.fusfilter(g,c) or cm.linkfilter(g,c)
end
--g:CheckSubGroup(cm.subfilter,1,g:GetCount(),c)