local m=31400096
local cm=_G["c"..m]
cm.name="星尘极限闪珖"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCondition(cm.sumcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.sumtg)
	e2:SetOperation(cm.sumop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
end
function cm.cfilter(c,tp)
	return c:IsSetCard(0xa3) and c:IsType(TYPE_SYNCHRO) and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,tp) end
	local tc=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,tp):GetFirst()
	if tc:IsLocation(LOCATION_MZONE) then
		local seq=tc:GetSequence()
		if seq==5 then seq=1 end
		if seq==6 then seq=3 end
		local p=tc:GetControler()-tp
		if p<0 then p=-p end
		e:SetLabel(seq+p*10)
		e:GetLabelObject():SetLabelObject(tc)
	else
		e:SetLabel(nil)
		e:GetLabelObject():SetLabelObject(nil)
	end
	Duel.Release(tc,REASON_COST)
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.seqfilter(c,seq_flag)
	local seq=seq_flag
	if seq>10 then
		seq=14-seq
	end
	local cseq=c:GetSequence()
	local d=math.abs(4-seq-cseq)
	return (d==0) or (d==1 and c:IsType(TYPE_MONSTER)) or (cseq==5 and math.abs(seq-3)<=1) or (cseq==6 and math.abs(seq-1)<=1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	local g
	if seq then
		g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(cm.seqfilter,nil,seq)
	end
	if Duel.NegateActivation(ev) and seq and #g>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_RULE)
	end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_LEAVE-RESET_TOGRAVE+RESET_PHASE+PHASE_END,0,0)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local spc=e:GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(m)>0 and spc:GetFlagEffect(m)>0 and spc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local spc=e:GetLabelObject()
	if spc:GetFlagEffect(m)>0 then
		Duel.SpecialSummon(spc,0,tp,tp,false,false,POS_FACEUP)
	end
end