--密林悍将归来
function c82568038.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,82568038)
	e2:SetTarget(c82568038.destg2)
	e2:SetOperation(c82568038.desop2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c82568038.sptg)
	e3:SetOperation(c82568038.spop)
	c:RegisterEffect(e3)
end
function c82568038.desfilter(c,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x825) and Duel.IsExistingMatchingCard(c82568038.pnfilter,tp,LOCATION_HAND,0,1,nil,code)
end
function c82568038.pnfilter(c,code)
	return c:IsSetCard(0x825) and c:IsType(TYPE_PENDULUM) and not c:IsCode(code)
end
function c82568038.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c82568038.desfilter,tp,LOCATION_PZONE,0,1,nil,tp) 
					 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c82568038.desfilter,tp,LOCATION_PZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c82568038.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568038,0))
	local g=Duel.SelectMatchingCard(tp,c82568038.pnfilter,tp,LOCATION_HAND,0,1,1,nil,code)
	if g:GetCount()>0 then
	local pn=g:GetFirst()
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		or not e:GetHandler():IsRelateToEffect(e) then return end
	 Duel.MoveToField(pn,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
end
end
function c82568038.filter(c,e,tp)
	return c:IsSetCard(0xa827) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82568038.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82568038.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c82568038.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568038.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
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
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		 local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e7:SetValue(1)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		 local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e8:SetValue(1)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e8)
		 local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(82568038,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetCountLimit(1)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_CANNOT_DISABLE)
		e6:SetLabel(fid)
		e6:SetLabelObject(tc)
		e6:SetCondition(c82568038.tdcon)
		e6:SetOperation(c82568038.tdop)
		Duel.RegisterEffect(e6,tp)
end
function c82568038.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(82568038)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c82568038.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
end