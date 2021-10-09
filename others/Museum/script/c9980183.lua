--刻刻帝女神 四之弹·Dalet
function c9980183.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c9980183.spcon)
	e1:SetTarget(c9980183.sptg1)
	e1:SetOperation(c9980183.spop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	 --Equip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,9980183)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTarget(c9980183.eqtg)
	e3:SetOperation(c9980183.eqop)
	c:RegisterEffect(e3) 
end
function c9980183.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSetCard(0x6bc8) 
end
function c9980183.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980183.cfilter,1,nil,tp)
end
function c9980183.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9980183.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c9980183.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc8)
end
function c9980183.filter2(c)
	return c:IsSetCard(0x6bc8) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9980183.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9980183.cfilter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9980183.cfilter2,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9980183.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9980183.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c9980183.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectMatchingCard(tp,c9980183.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	local sc=sg:GetFirst()
	if sc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,sc,tc,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9980183.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(300)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		sc:RegisterEffect(e3)
	end
end
function c9980183.eqlimit(e,c)
	return e:GetLabelObject()==c
end
