--方舟骑士庇护者模组·“封闭的希望”
function c82568099.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(c82568099.target)
	e1:SetOperation(c82568099.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c82568099.eqlimit)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(600)
	c:RegisterEffect(e3)
	--Sanctuary
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCountLimit(1,82568099)
	e0:SetCost(c82568099.cost11)
	e0:SetTarget(c82568099.tg11)
	e0:SetOperation(c82568099.op11)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,82568199)
	e4:SetTarget(c82568099.tg12)
	e4:SetOperation(c82568099.op12)
	c:RegisterEffect(e4)
end
function c82568099.nightingalefilter2(c)
	return c:IsFaceup() and (c:IsCode(82567786) or c:IsCode(82567787) or c:IsCode(82568087) or c:IsCode(82568086)) and c:IsAttackAbove(3000)
end
function c82568099.nightingalefilter3(c)
	return c:IsFaceup() and (c:IsCode(82567786) or c:IsCode(82567787) or c:IsCode(82568087) or c:IsCode(82568086)) and c:IsAttackBelow(2999)
end
function c82568099.cost11(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568099.nightingalefilter2,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568099,0))
	local ni=Duel.SelectMatchingCard(tp,c82568099.nightingalefilter2,tp,LOCATION_MZONE,0,1,1,nil)
	 local   nii=ni:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		nii:RegisterEffect(e1)
	end
function c82568099.tg11(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
end
function c82568099.op11(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c82568099.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
end
function c82568099.aclimit(e,re,tp)
	if not re:GetHandler():IsType(TYPE_MONSTER) then return false end
	return re:GetHandler():IsLevelBelow(6)
end
function c82568099.tg12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsSetCard(0x825) and chkc:IsFaceup() and c82568099.nightingalefilter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82568099.nightingalefilter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568099,1))
	Duel.SelectTarget(tp,c82568099.nightingalefilter3,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82568099.op12(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
  then  local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c82568099.eqlimit(e,c)
	return c:IsCode(82567786,82567787,82568086,82568087)
end
function c82568099.filter(c)
	return c:IsFaceup() and c:IsCode(82567786,82567787,82568086,82568087)
end
function c82568099.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c82568099.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82568099.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c82568099.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c82568099.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
