--魔偶甜点圣宴
function c10700447.initial_effect(c)
	--Activate  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_ACTIVATE)  
	e0:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e0)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700447,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,10700447)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c10700447.target)
	e1:SetOperation(c10700447.operation)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c10700447.intg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c10700447.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c10700447.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c10700447.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700447.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10700447.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsFacedown() then
		Duel.ConfirmCards(1-tp,tc)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	if not tc:IsType(0x4800000) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
	end
end
function c10700447.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x71) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(lv)
end
function c10700447.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
		local lv=tc:GetLevel()
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(c10700447.indtg)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetValue(500)
			Duel.RegisterEffect(e1,tp)
			if (not tc:IsType(0x4800000)) and Duel.GetLocationCount(tp,0x04)>0 and Duel.IsExistingMatchingCard(c10700447.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv) and Duel.SelectYesNo(tp,aux.Stringid(10700447,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,c10700447.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
				if #g>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
function c10700447.indtg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0x71)
end
function c10700447.intg(e,c)
	return c:IsSetCard(0x71)
end