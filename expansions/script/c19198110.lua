--风云机巧舰
function c19198110.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,19198110+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19198110.target)
	e1:SetOperation(c19198110.activate)
	c:RegisterEffect(e1)
local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
   -- e3:SetCost(aux.bfgcost)
	e3:SetTarget(c19198110.target2)
	e3:SetOperation(c19198110.operation2)
	c:RegisterEffect(e3)
end
function c19198110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,19198109,0,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c19198110.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,19198109,0,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) then return end
	local token=Duel.CreateToken(tp,19198109)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c19198110.filter2(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_EFFECT)
end
function c19198110.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19198110.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19198110.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c19198110.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c19198110.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_EARTH) and tc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e3)
	end
end