local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_END)
	e1:SetCondition(s.con)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_END)
	e2:SetCondition(s.con)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsLevelBelow(2) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc) end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil) and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function s.filter2(c,tp)
	return c:IsFaceup() and c:IsLevelBelow(2) and not c:IsAttribute(ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK,0,1,nil,tp,c)
end
function s.eqfilter(c,tp,ec)
	return c:IsSetCard(0xc538) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(ec)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and c:IsAbleToRemove() and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eqc=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp,tc):GetFirst()
		local c=e:GetHandler()
		if eqc and Duel.Equip(tp,eqc,tc) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:IsLocation(LOCATION_REMOVED) then
			eqc:RegisterFlagEffect(id+50,RESET_EVENT+0x1620000,0,1,c:GetFieldID())
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_DESTROYED)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCondition(s.regcon)
			e1:SetOperation(s.regop)
			e1:SetReset(RESET_EVENT+0x1620000)
			eqc:RegisterEffect(e1,true)
		end
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),e:GetOwner()
	local res=false
	for _,flag in ipairs({c:GetFlagEffectLabel(id+50)}) do if flag==tc:GetFieldID() then res=true end end
	return res
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),e:GetOwner()
	c:ResetFlagEffect(id+50)
	c:RegisterFlagEffect(id+50,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetFieldID())
	local e1=Effect.CreateEffect(tc)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetOperation(s.retop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c,eqc=e:GetOwner(),e:GetLabelObject()
	local fid=c:GetFieldID()
	local res=false
	for _,flag in ipairs({eqc:GetFlagEffectLabel(id+50)}) do if flag==c:GetFieldID() then res=true end end
	if Duel.ReturnToField(c) and res and eqc:CheckEquipTarget(c) then Duel.Equip(tp,eqc,c) end
end
