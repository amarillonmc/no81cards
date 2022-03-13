--巧壳匠 莉赛露
function c67200553.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(67200553)
	aux.AddLinkProcedure(c,c67200553.mfilter,1,1)  
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67200553)
	e1:SetTarget(c67200553.eqtg)
	e1:SetOperation(c67200553.eqop)
	c:RegisterEffect(e1)   
end
function c67200553.mfilter(c)
	return c:IsLinkSetCard(0x676) and c:IsLinkType(TYPE_PENDULUM)
end
--
function c67200553.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x676) and Duel.IsExistingMatchingCard(c67200553.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetOriginalAttribute(),tp)
end
function c67200553.eqfilter(c,att,race,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x676) and c:IsType(TYPE_PENDULUM) and c:GetOriginalAttribute()~=att and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c67200553.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67200553.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67200553.filter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c67200553.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c67200553.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c67200553.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetOriginalAttribute(),tp)
		local sc=g:GetFirst()
		if not sc then return end
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c67200553.eqlimit)
		sc:RegisterEffect(e1)
	end
end
function c67200553.eqlimit(e,c)
	return c==e:GetLabelObject()
end

