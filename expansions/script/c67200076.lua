--创刻-源鸦鸟『不详之爪』
function c67200076.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE)
	e1:SetCountLimit(1,67200076+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c67200076.activate)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200076,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c67200076.eqtg)
	e2:SetOperation(c67200076.eqop)
	c:RegisterEffect(e2)   
end
--
function c67200076.filter(c)
	return c:IsSetCard(0xc673) and c:IsAbleToHand()
end
function c67200076.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c67200076.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200076,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--
function c67200076.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc673)
		and Duel.IsExistingMatchingCard(c67200076.eqfilter,tp,LOCATION_ONFIELD,0,1,nil,0,0,tp)
end
function c67200076.eqfilter(c,att,race,tp)
	return c:IsType(TYPE_TRAP) and c:IsOnField() and not c:IsForbidden()
end
function c67200076.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67200076.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67200076.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c67200076.eqfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c67200076.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_ONFIELD)
end
function c67200076.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c67200076.eqfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		local sc=g:GetFirst()
		if not sc then return end
		local res=sc:IsLocation(LOCATION_ONFIELD)
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c67200076.eqlimit)
		sc:RegisterEffect(e1)
		--atk up
		local e2=Effect.CreateEffect(sc)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
	end
end
function c67200076.eqlimit(e,c)
	return c==e:GetLabelObject()
end

