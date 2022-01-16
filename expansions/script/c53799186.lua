local m=53799186
local cm=_G["c"..m]
cm.name="幻兽机 渡空搏鱼"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.matfilter,nil,nil,aux.NonTuner(nil),1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(cm.desop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.matfilter(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsType(TYPE_TOKEN)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsType,1,nil,TYPE_TOKEN) then Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1) end
end
function cm.filter(c,e,tp,z)
	return c:IsSetCard(0x101b) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,z)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if seq==5 then seq=1 end
	if seq==6 then seq=3 end
	local z=0
	z=z|(1<<(seq-1))
	z=z|(1<<(seq+1))
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and seq~=0 and seq~=4
		and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)
		and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp,z)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp,z) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if seq==5 then seq=1 end
	if seq==6 then seq=3 end
	local z=0
	z=z|(1<<(seq-1))
	z=z|(1<<(seq+1))
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or c:IsFacedown() or not c:IsRelateToEffect(e) or seq==0 or seq==4 or not Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) or not Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then return end
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp,z)
	local g2=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp,z)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	if Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP,z)~=0 then
		local g=Group.CreateGroup()
		sg=sg1:Filter(Card.IsOnField,nil)
		for tc in aux.Next(sg) do
			c:SetCardTarget(tc)
			g:AddCard(tc)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
			c:RegisterFlagEffect(m,RESET_EVENT+0x1020000,0,0)
		end
		g:KeepAlive()
		e:SetLabelObject(g)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():GetLabelObject()
	if #g>0 and e:GetHandler():GetFlagEffect(m)~=0 then
		for tc in aux.Next(g) do
			if tc:GetFlagEffect(m)~=0 then Duel.Destroy(tc,REASON_EFFECT) end
		end
	end
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x101b) and c:IsLevelBelow(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(0,m)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
