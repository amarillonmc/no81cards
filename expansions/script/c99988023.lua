--亡语魔道具 怠惰之戒指
function c99988023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCountLimit(1,99988023+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99988023.target)
	e1:SetOperation(c99988023.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CONTROL_CHANGED)
	e3:SetCondition(c99988023.damcon)
	e3:SetOperation(c99988023.damop)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99988023,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c99988023.rettg)
	e4:SetOperation(c99988023.retop)
	c:RegisterEffect(e4)
	--Equip limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c99988023.eqlimit)
	c:RegisterEffect(e5)
	end
function c99988023.eqlimit(e,c)
	return not c:IsSetCard(0x20df)
end
function c99988023.filter(c)
	return c:IsFaceup() and not c:IsSetCard(0x20df)
end
function c99988023.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c99988023.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99988023.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99988023.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99988023.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c99988023.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetEquipTarget()
	return tg and eg:IsContains(tg)
end
function c99988023.damop(e,tp,eg,ep,ev,re,r,rp)	
	local ec=e:GetHandler():GetEquipTarget()
	Duel.SetLP(ec:GetOwner(),Duel.GetLP(ec:GetOwner())-ec:GetBaseAttack())
  end
function c99988023.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(e:GetHandler():GetEquipTarget())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99988023.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoHand(c,nil,REASON_EFFECT) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
	   Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
