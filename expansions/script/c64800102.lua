--神代丰的铁骑 巨大冲击
function c64800102.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c64800102.lcheck)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800102,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,64800102)
	e1:SetTarget(c64800102.eqtg)
	e1:SetOperation(c64800102.eqop)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64800102,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,64810102)
	e2:SetCondition(c64800102.rmcon)
	e2:SetTarget(c64800102.rmtg)
	e2:SetOperation(c64800102.rmop)
	c:RegisterEffect(e2)
end
function c64800102.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x641a)
end

--e1
function c64800102.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x641a) and not c:IsCode(64800097)
end
function c64800102.eqfilter1(c,tp)
	return c:IsCode(64800097)
end
function c64800102.eqfilter2(c,tp)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c64800102.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c64800102.cfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingTarget(c64800102.cfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c64800102.eqfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c64800102.eqfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c64800102.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,2,0,0)
end
function c64800102.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c64800102.eqfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c64800102.eqfilter2,tp,0,LOCATION_MZONE,1,nil)
	then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c64800102.eqfilter1),tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
		local tc1=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local g2=Duel.SelectMatchingCard(tp,c64800102.eqfilter2,tp,0,LOCATION_MZONE,1,1,nil)
		local tc2=g2:GetFirst()
		if tc1 and tc2 then
			if not (Duel.Equip(tp,tc1,tc,false) and Duel.Equip(tp,tc2,tc,false)) then return end
				local e1=Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(c64800102.eqlimit)
				e1:SetLabelObject(tc)
				tc1:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_EQUIP_LIMIT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(c64800102.eqlimit)
				e2:SetLabelObject(tc)
				tc2:RegisterEffect(e2)
		end
	end
end
function c64800102.eqlimit(e,c)
	return c==e:GetLabelObject()
end

--e2
function c64800102.smfilter(c)
	return c:IsFaceup() and c:IsCode(64800097)
end
function c64800102.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c64800102.smfilter,1,nil)
end
function c64800102.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_ONFIELD and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_ONFIELD)
end
function c64800102.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end