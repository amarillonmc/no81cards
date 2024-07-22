--圣树修正者 启明
function c67200966.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(67200966,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,67200966)  
	e1:SetTarget(c67200966.target)
	e1:SetOperation(c67200966.activate)
	c:RegisterEffect(e1) 
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200966,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,67200967) 
	e4:SetCondition(c67200966.descon)
	e4:SetTarget(c67200966.destg)
	e4:SetOperation(c67200966.desop)
	c:RegisterEffect(e4)
	--level down
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200966,2))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c67200966.lvtg)
	e3:SetOperation(c67200966.lvop)
	c:RegisterEffect(e3)
end
function c67200966.tgfilter(c,e,tp)
	if not (c:IsFaceup() and c:IsSetCard(0x67a)) then return false end
	return Duel.IsExistingMatchingCard(c67200966.atkspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c67200966.atkspfilter(c,e,tp,code)
	return c:IsSetCard(0x667a) and not c:IsCode(code) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200966.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
		and chkc:IsFaceup() and chkc:IsSetCard(0x67a) end
	if chk==0 then return Duel.IsExistingTarget(c67200966.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c67200966.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	--Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c67200966.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c67200966.atkspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
		if g:GetCount()>0 and Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true) and c:IsRelateToEffect(e) then
			Duel.SendtoExtraP(e:GetHandler(),nil,REASON_EFFECT)
		end
	end
end
--
function c67200966.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c67200966.spfilter2(c,e,tp)
	return c:IsSetCard(0x667a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200966.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and chkc~=c and c67200966.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67200966.spfilter2,tp,LOCATION_PZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67200966.spfilter2,tp,LOCATION_PZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67200966.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200966.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x67a) and c:GetLevel()>0
end
function c67200966.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67200966.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200966.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c67200966.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c67200966.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
