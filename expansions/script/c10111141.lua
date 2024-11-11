function c10111141.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111141,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,10111141)
	e1:SetCondition(c10111141.spcon)
	e1:SetTarget(c10111141.sptg)
	e1:SetOperation(c10111141.spop)
	c:RegisterEffect(e1)
        --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111141,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,101111410)
    e2:SetCost(c10111141.spcost)
	e2:SetTarget(c10111141.settg)
	e2:SetOperation(c10111141.setop)
	c:RegisterEffect(e2)
end
function c10111141.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	e:SetLabelObject(tc)
	return tc and tc:IsControler(tp) and tc:IsSetCard(0x9008)
end
function c10111141.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10111141.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if g:GetCount()==0 then return end
	local g1,atk=g:GetMaxGroup(Card.GetAttack)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(atk)
		c:RegisterEffect(e1,true)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
	end
end
function c10111141.tgfi1ter(c)
	return c:IsSetCard(0x9008) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsCode(10111141)
end
function c10111141.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c10111141.tgfi1ter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
    local sg=Duel.SelectMatchingCard(tp,c10111141.tgfi1ter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
    sg:AddCard(e:GetHandler())
    Duel.SendtoGrave(sg,REASON_COST+REASON_RETURN)
end
function c10111141.setfilter(c)
	return aux.IsCodeOrListed(c,10111128) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10111141.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111141.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c10111141.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10111141.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end