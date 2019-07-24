--零诺斯·织女星形态
function c9980601.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c9980601.lcheck)
	c:EnableReviveLimit()
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980601.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9980601)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c9980601.eftg)
	e2:SetOperation(c9980601.efop)
	c:RegisterEffect(e2)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9980601.atkval)
	c:RegisterEffect(e2)
end
function c9980601.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980601,2))
end 
function c9980601.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3bcd)
end
function c9980601.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x6bcb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980601.eqfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3bcd) and Duel.IsExistingMatchingCard(c9980601.eqfilter2,tp,LOCATION_GRAVE,0,1,nil,c,tp)
end
function c9980601.eqfilter2(c,tc,tp)
	return c:IsSetCard(0x6bcb) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9980601.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c9980601.spfilter(chkc,e,tp)
		else return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9980601.eqfilter1(chkc,tp) end
	end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c9980601.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c9980601.eqfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9980601,0),aux.Stringid(9980601,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9980601,0))
	else op=Duel.SelectOption(tp,aux.Stringid(9980601,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c9980601.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(CATEGORY_EQUIP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c9980601.eqfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	end
end
function c9980601.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980601,2))
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		local ec=Duel.GetFirstTarget()
		if ec:IsRelateToEffect(e) and ec:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9980601.eqfilter2),tp,LOCATION_GRAVE,0,1,1,nil,ec,tp)
			local tc=g:GetFirst()
			if not tc or not Duel.Equip(tp,tc,ec,true) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c9980601.eqlimit2)
			e1:SetLabelObject(ec)
			tc:RegisterEffect(e1)
		   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980601,3))
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c9980601.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c9980601.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x6bcb,0x3bcd)
end
function c9980601.eqlimit2(e,c)
	return c==e:GetLabelObject()
end
function c9980601.atkval(e,c)
	return c:GetEquipGroup():FilterCount(Card.IsSetCard,nil,0x6bcb)*300
end
