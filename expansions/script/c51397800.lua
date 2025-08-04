local s,id,o=GetID()
function s.initial_effect(c)
    --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_BECOME_TARGET)
	e0:SetCountLimit(1,id)
	e0:SetCondition(s.cpcon)
	e0:SetOperation(s.cpop)
	c:RegisterEffect(e0)
    --flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAIN_END)
        e1:SetLabelObject(c) 
        e1:SetCountLimit(1)
        e1:SetCondition(s.retcon)
        e1:SetOperation(s.retop)
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+EVENT_CHAIN_END) 
        Duel.RegisterEffect(e1,tp)
    end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)~=0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
    if c:IsOnField() and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
        local pos=0
		if c:IsCanTurnSet() then
			pos=Duel.SelectPosition(tp,c,POS_DEFENSE)
		else
			pos=Duel.SelectPosition(tp,c,POS_FACEUP_DEFENSE)
		end
		Duel.ChangePosition(c,pos)
    end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xa14) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,0x01,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)<=0 then return end
	Duel.Hint(3,tp,509)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,0x01,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local c=e:GetHandler()
        --destroy
	    local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id,2))
	    e1:SetCategory(CATEGORY_DESTROY)
        e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	    e1:SetType(EFFECT_TYPE_QUICK_O) 
	    e1:SetCode(EVENT_FREE_CHAIN)
	    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetCountLimit(1)
	    e1:SetTarget(s.destg)
        e1:SetOperation(s.desop)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	    tc:RegisterEffect(e1)
        --Atk/Def Change
        local batk=tc:GetAttack()
		local bdef=tc:GetDefense()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK)
		e2:SetValue(bdef)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_SET_DEFENSE)
		e3:SetValue(batk)
		tc:RegisterEffect(e3)
        Duel.SpecialSummonComplete()
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0x04,0x04,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0x04,0x04,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) and c:IsOnField() and c:IsCanTurnSet() then
            Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
        end
	end
end