--同盟械斗
function c188812.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c188812.aclimit)
	e1:SetCondition(c188812.actcon)
	c:RegisterEffect(e1)   
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c188812.xeqtg)
	e4:SetOperation(c188812.xeqop)
	c:RegisterEffect(e4) 
end
function c188812.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x137) and c:IsControler(tp)
end
function c188812.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c188812.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c188812.cfilter(a,tp)) or (d and c188812.cfilter(d,tp))
end
function c188812.unfil1(c,tp)
	return c:IsType(TYPE_UNION) and Duel.IsExistingMatchingCard(c188812.unfil2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp,c) and Duel.IsExistingMatchingCard(c188812.tgfil,tp,LOCATION_DECK,0,1,nil,tp,c)
end
function c188812.unfil2(c,tp,tc)
	return aux.CheckUnionEquip(c,tc) and c:CheckUnionTarget(tc) and c:IsType(TYPE_UNION) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:GetRace()==tc:GetRace() and c:GetAttribute()==tc:GetAttribute()  
end
function c188812.tgfil(c,tp,tc)
	return c:IsType(TYPE_UNION) and c:GetRace()==tc:GetRace() and c:GetAttribute()~=tc:GetAttribute() and c:IsAbleToGrave()   
end
function c188812.xeqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c188812.unfil1,tp,LOCATION_MZONE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,c188812.unfil1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)	 
end
function c188812.xeqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c188812.unfil2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp,tc)
		local ec=g:GetFirst()
		if ec and aux.CheckUnionEquip(ec,tc) and Duel.Equip(tp,ec,tc) then
		aux.SetUnionState(ec)
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c188812.tgfil,tp,LOCATION_DECK,0,1,1,nil,tp,tc)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end





