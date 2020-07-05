--企鹅物流·行动-火蓝之心
function c79029056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029056+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c79029056.target)
	e1:SetOperation(c79029056.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c79029056.handcon)
	c:RegisterEffect(e2)
end
function c79029056.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029056.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c79029056.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029056.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79029056.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c79029056.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local xx=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
			tc:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
			e4:SetRange(LOCATION_MZONE)
			e4:SetTargetRange(0,LOCATION_MZONE)
			e4:SetValue(c79029056.atklimit)
			tc:RegisterEffect(e4)
end
end
function c79029056.atklimit(e,c)
	return c~=e:GetHandler()
end
function c79029056.f(c)
	return c:IsFaceup() and c:IsSetCard(0x1902) and c:IsType(TYPE_MONSTER)
end
function c79029056.handcon(e)
	return Duel.IsExistingMatchingCard(c79029056.f,tp,LOCATION_MZONE,0,1,nil)
end