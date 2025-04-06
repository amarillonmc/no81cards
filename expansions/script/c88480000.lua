--熵增焓减黑体龙
function c88480000.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88480000)
	e1:SetCost(c88480000.spcost)
	e1:SetTarget(c88480000.sptg)
	e1:SetOperation(c88480000.spop)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c88480000.lvtg)
	e2:SetOperation(c88480000.lvop)
	c:RegisterEffect(e2)
end
function c88480000.costfilter(c)
	return c:IsRace(RACE_WYRM) and not c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_TUNER)
		and (c:IsAbleToGraveAsCost() or c:IsAbleToRemoveAsCost())
end
function c88480000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88480000.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c88480000.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	local b1=tc:IsAbleToGraveAsCost()
	local b2=tc:IsAbleToRemoveAsCost()
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(88480000,0)},{b2,aux.Stringid(88480000,1)})
	if op==1 then
		Duel.SendtoGrave(tc,REASON_COST)
	elseif op==2 then
		Duel.Remove(tc,0x5,REASON_COST)
	end
end
function c88480000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88480000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c88480000.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and not c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(1)
end
function c88480000.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c88480000.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88480000.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c88480000.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:IsLevel(1) then op=Duel.SelectOption(tp,aux.Stringid(88480000,2))
	else op=Duel.SelectOption(tp,aux.Stringid(88480000,2),aux.Stringid(88480000,3)) end
	e:SetLabel(op)
end
function c88480000.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end