--void-约束之弓
function c1008034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1008034.target)
	e1:SetOperation(c1008034.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c1008034.eqlimit)
	c:RegisterEffect(e3)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c1008034.efilter)
	c:RegisterEffect(e1)
	--set monster
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c1008034.setcon)
	e3:SetOperation(c1008034.setop)
	c:RegisterEffect(e3)
	local ore=Effect.CreateEffect(c)
	ore:SetCode(EFFECT_CHANGE_TYPE)
	ore:SetType(EFFECT_TYPE_SINGLE)
	ore:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	ore:SetRange(0xff)
	ore:SetValue(0x40002)
	c:RegisterEffect(ore)
end
function c1008034.eqlimit(e,c)
	return c:IsSetCard(0x320e)
end
function c1008034.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end
function c1008034.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x320e)
end
function c1008034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1008034.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1008034.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1008034.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c1008034.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c1008034.setcon(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local c=e:GetHandler():GetEquipTarget()
	local bc=c:GetBattleTarget()
	return d and a==c and bc and bc~=c and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
end
function c1008034.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetAttackTarget()
	if tc:IsImmuneToEffect(e) then return end
	local pos=POS_FACEUP
	if tc:IsPosition(POS_FACEDOWN) then pos=POS_FACEDOWN end
	if tc:IsType(TYPE_PENDULUM) then
		local bseq=0
		while Duel.CheckLocation(1-tp,LOCATION_SZONE,bseq)==0 and bseq<5 do
			bseq=bseq+1
		end
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,pos,true)
		Duel.MoveSequence(tc,bseq)
	else
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,pos,true)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e1)
	Duel.NegateAttack()
end
