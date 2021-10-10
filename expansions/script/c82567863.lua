--不畏苦暗！
function c82567863.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82567863)
	e1:SetTarget(c82567863.cttg)
	e1:SetOperation(c82567863.ctop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(82567863,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1+EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c82567863.sptg)
	e2:SetOperation(c82567863.spop)
	c:RegisterEffect(e2)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567863,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1+EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c82567863.pctg)
	e3:SetOperation(c82567863.pcop)
	c:RegisterEffect(e3)
end
function c82567863.tkfilter(c)
	return c:GetDefense()>0 and c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567863.fieldfilter(c)
	return (c:IsSetCard(0xa825) or c:IsSetCard(0xc826)) and c:IsFaceup()
end
function c82567863.thfilter(c)
	return c:IsSetCard(0x825) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c82567863.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:GetDefense()>0 and chkc:IsSetCard(0x825) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567863.tkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567863.tkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	 Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	 local tc=g:GetFirst():GetDefense()/2
	 Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1,tp,tc)
end
function c82567863.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local value=tc:GetDefense()
	Duel.Recover(tp,value,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c82567863.fieldfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c82567863.thfilter,tp,LOCATION_DECK,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(82567863,2))  then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82567863.thfilter,tp,LOCATION_DECK,0,0,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
end
function c82567863.filter(c,e,tp)
	return  c:IsSetCard(0xc826) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82567863.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82567863.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c82567863.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567863.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	if ct==0 then return end
	local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		 local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e7:SetValue(1)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		 local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(82567863,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetCountLimit(1)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_CANNOT_DISABLE)
		e6:SetLabel(fid)
		e6:SetLabelObject(tc)
		e6:SetCondition(c82567863.tdcon)
		e6:SetOperation(c82567863.tdop)
		Duel.RegisterEffect(e6,tp)
end
function c82567863.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(82567863)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c82567863.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
end
function c82567863.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x825) and not c:IsForbidden() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c82567863.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c82567863.pcfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c82567863.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c82567863.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end