--方舟骑士团-魔王
c29071250.named_with_Arknight=1
function c29071250.initial_effect(c)
	aux.AddCodeList(c,29079596,29065500,29065502,29056009)
	aux.EnableChangeCode(c,29079596)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29071250)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c29071250.spcon1)
	e1:SetTarget(c29071250.sptg)
	e1:SetOperation(c29071250.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c29071250.spcon2)
	c:RegisterEffect(e2)
end
function c29071250.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0
end
function c29071250.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
end
function c29071250.filter(c)
	return c:IsFaceup() and c:IsCode(29065500,29065502,29056009)
end
function c29071250.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c29071250.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c29071250.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	Duel.SelectTarget(tp,c29071250.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c29071250.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(c29071250.efilter)
			e1:SetOwnerPlayer(tp)
			tc:RegisterEffect(e1)
		end
end
function c29071250.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
















