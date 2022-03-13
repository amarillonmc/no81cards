--青玉之爪
local m=7419808
local cm=_G["c"..m]
cm.named_with_Qingyu=1
function cm.Qingyu(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Qingyu
end
function cm.Qingyu_code(tp)
	local val=Duel.GetFlagEffect(tp,7419700)
	if val>=20 then
		return 7419703
	elseif val>=7 then
		return 7419702
	elseif val>=4 then
		return 7419701
	else
		return 7419700
	end
	return 7419700
end

function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	--Activate
	--local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_EQUIP)
	--e1:SetType(EFFECT_TYPE_ACTIVATE)
	--e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	--e1:SetTarget(cm.target)
	--e1:SetOperation(cm.operation)
	--c:RegisterEffect(e1)
	--Atk up
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_EQUIP)
	--e2:SetCode(EFFECT_UPDATE_ATTACK)
	--e2:SetValue(1000)
	--c:RegisterEffect(e2)
	--Equip limit
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_SINGLE)
	--e3:SetCode(EFFECT_EQUIP_LIMIT)
	--e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e3:SetValue(cm.eqlimit)
	--c:RegisterEffect(e3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(cm.tgop)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function cm.filter(c)
	return c:IsFaceup() and cm.Qingyu(c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,7419700,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_ROCK,ATTRIBUTE_WIND) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Equip(tp,c,tc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,7419700,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_ROCK,ATTRIBUTE_WIND) then
			Duel.RegisterFlagEffect(tp,7419700,0,0,1)
			local token=Duel.CreateToken(tp,cm.Qingyu_code(tp))
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetOperation(cm.sucop)
			Duel.RegisterEffect(e2,tp)
			--local e1=Effect.CreateEffect(e:GetHandler())
			--e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			--e1:SetCode(EVENT_PHASE+PHASE_END)
			--e1:SetCountLimit(1)
			--e1:SetCondition(cm.thcon2)
			--e1:SetOperation(cm.thop2)
			--e1:SetReset(RESET_PHASE+PHASE_END)
			--Duel.RegisterEffect(e1,tp)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)
	else
		c:CancelToGrave(false)
	end
end
function cm.eqlimit(e,c)
	return cm.Qingyu(c)
end
function cm.filter(c)
	return c:IsFaceup() and cm.Qingyu(c)
end
--function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
--  if chkc then return chkc:GetLocation()==LOCATION_MZONE and cm.filter(chkc) end
--  if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
--  and Duel.IsPlayerCanSpecialSummonMonster(tp,7419700,0,TYPES_TOKEN_MONSTER+TYPE_PENDULUM,0,0,1,RACE_ROCK,ATTRIBUTE_WIND) end
--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
--  Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
--  Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
--  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
--  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
--end
--function cm.operation(e,tp,eg,ep,ev,re,r,rp)
--  local tc=Duel.GetFirstTarget()
--  if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
--  if Duel.Equip(tp,e:GetHandler(),tc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
--  and Duel.IsPlayerCanSpecialSummonMonster(tp,7419700,0,TYPES_TOKEN_MONSTER+TYPE_PENDULUM,0,0,1,RACE_ROCK,ATTRIBUTE_WIND) then
--  Duel.RegisterFlagEffect(tp,7419700,0,0,1)
--  local token=Duel.CreateToken(tp,cm.Qingyu_code(tp))
--  Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
--  local e2=Effect.CreateEffect(e:GetHandler())
--  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
--  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
--  e2:SetOperation(cm.sucop)
--  Duel.RegisterEffect(e2,tp)
--  end
--  end
--end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function cm.sucfilter(c,tp)
	return c:IsCode(7419700) and c:GetControler()==tp
end
function cm.sucop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(cm.sucfilter,nil,tp)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(tc:GetBaseAttack()+500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(tc:GetBaseDefense()+500)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_UPDATE_LEVEL)
			e3:SetValue(1)
			tc:RegisterEffect(e3)
			tc=tg:GetNext()
		end
	end
end
