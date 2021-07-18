--妖圣骑士 兰斯洛特
function c40009780.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009780+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c40009780.spcon)
	e1:SetOperation(c40009780.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--Equip change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c40009780.eqcon)
	e2:SetOperation(c40009780.eqop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--SPECIAL SUMMON
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009780,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40009781)
	e3:SetCondition(c40009780.spcon1)
	e3:SetTarget(c40009780.sptg1)
	e3:SetOperation(c40009780.spop1)
	c:RegisterEffect(e3)
end
function c40009780.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c)
end
function c40009780.eqfilter(c,ec)
	return c:IsSetCard(0x207a) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c40009780.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)
	local tc=g:GetFirst()
	e:SetLabel(0)
	if Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)>0 and tc:IsSetCard(0x107a) then e:SetLabel(1) end
end
function c40009780.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c40009780.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabelObject():GetLabel()==1 and Duel.IsExistingMatchingCard(c40009780.eqfilter,tp,LOCATION_DECK,0,1,nil,c) and Duel.SelectYesNo(tp,aux.Stringid(40009780,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c40009780.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
		local tc1=g:GetFirst()
		if tc1 then
			Duel.Equip(tp,tc1,c)
		end
	end
end
function c40009780.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function c40009780.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x207a)
end
function c40009780.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c40009780.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009780.filter1,tp,LOCATION_SZONE,0,1,nil) 
	and Duel.GetLocationCount(tp,LOCATION_MZONE,tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c40009780.filter1,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c40009780.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp)<=0 then return end
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_MONSTER+TYPE_NORMAL)
		e1:SetReset(RESET_EVENT+RESET_TOHAND+RESET_TOGRAVE+RESET_TODECK+RESET_REMOVE)
		tc:RegisterEffect(e1,true)  
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_WARRIOR)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_LIGHT)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tc:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(3)
		tc:RegisterEffect(e6,true)
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) 
		Duel.SpecialSummonComplete()
	end
end

