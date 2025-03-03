--人理之诗 天之锁
function c22022080.initial_effect(c)
	aux.AddCodeList(c,22022070,22022090)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c22022080.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,22022080+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22022080.eqtg)
	e1:SetOperation(c22022080.eqop)
	c:RegisterEffect(e1)
end
function c22022080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.SelectOption(tp,aux.Stringid(22022080,0))
	end
end
function c22022080.filter(c)
	return c:IsFaceup() and c:IsCode(22022090)
end
function c22022080.handcon(e)
	return Duel.IsExistingMatchingCard(c22022080.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c22022080.cfilter(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(c22022080.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp)
end
function c22022080.eqfilter(c,att,race,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCode(22022070) and c:CheckUniqueOnField(tp)
end
function c22022080.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22022080.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22022080.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22022080.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c22022080.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c22022080.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc:GetOriginalAttribute(),tc:GetOriginalRace(),tp)
		local sc=g:GetFirst()
		if not sc then return end
		local res=sc:IsLocation(LOCATION_DECK)
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c22022080.eqlimit)
		sc:RegisterEffect(e1)
		if res then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetTargetRange(1,0)
			e3:SetLabel(22022070)
			e3:SetTarget(c22022080.splimit)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c22022080.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c22022080.splimit(e,c)
	return c:IsCode(e:GetLabel())
end