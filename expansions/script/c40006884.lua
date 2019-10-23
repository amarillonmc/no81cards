--一人千面·佐罗
function c40006884.initial_effect(c)
	c:SetSPSummonOnce(40006884)
	c:SetUniqueOnField(1,0,40006884)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c40006884.matfilter,1,1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40006884,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c40006884.condition)
	e1:SetTarget(c40006884.eqtg)
	e1:SetOperation(c40006884.eqop)
	c:RegisterEffect(e1)   
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40006884,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,40006884)
	e2:SetCondition(c40006884.thcon)
	e2:SetTarget(c40006884.thtg)
	e2:SetOperation(c40006884.thop)
	c:RegisterEffect(e2) 
end
function c40006884.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40006884.matfilter(c)
	return c:IsLinkSetCard(0xdf1d) and not c:IsLinkCode(40006884)
end
function c40006884.filter(c)
	return not c:IsCode(40006884) and c:IsSetCard(0xdf1d) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c40006884.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40006884.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c40006884.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c40006884.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c40006884.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c40006884.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c40006884.eqlimit(e,c)
	return e:GetOwner()==c
end
function c40006884.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c40006884.filter2(c,e,tp)
	return not c:IsCode(40006884) and c:IsSetCard(0xdf1d) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c40006884.filter3(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
		and c:IsType(TYPE_MONSTER)
end
function c40006884.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006884.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c40006884.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c40006884.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c40006884.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40006884,3))
	local g=Duel.SelectMatchingCard(tp,c40006884.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc:IsImmuneToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40006884,2))
		local g1=Duel.SelectMatchingCard(tp,c40006884.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			local tc2=g1:GetFirst()
			if tc2:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(g1) end
			Duel.Equip(tp,tc2,tc,true,true)
			Duel.EquipComplete()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c40006884.eqlimit2)
			e1:SetLabelObject(tc)
			tc2:RegisterEffect(e1)
		end
	end
end
function c40006884.eqlimit2(e,c)
	return c==e:GetLabelObject()
end