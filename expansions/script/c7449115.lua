--昆虫利爪
function c7449115.initial_effect(c)
	aux.AddCodeList(c,7449105)
	--Equip limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(c7449115.eqlimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c7449115.target)
	e1:SetOperation(c7449115.activate)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c7449115.atkcost)
	e2:SetTarget(c7449115.atktg)
	e2:SetOperation(c7449115.atkop)
	c:RegisterEffect(e2)
	--effect gain
	local ge3=Effect.CreateEffect(c)
	ge3:SetType(EFFECT_TYPE_SINGLE)
	ge3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	ge3:SetValue(c7449115.damval)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c7449115.eftg)
	e3:SetLabelObject(ge3)
	c:RegisterEffect(e3)
	local ge4=ge3:Clone()
	ge4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	local e4=e3:Clone()
	e4:SetLabelObject(ge4)
	c:RegisterEffect(e4)
	local ge5=Effect.CreateEffect(c)
	ge5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge5:SetCode(EVENT_BATTLED)
	ge5:SetOperation(c7449115.adjustop)
	local e5=e3:Clone()
	e5:SetLabelObject(ge5)
	c:RegisterEffect(e5)
	--set
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(7449115,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e6:SetCountLimit(1,7449115)
	e6:SetCondition(c7449115.setcon)
	e6:SetTarget(c7449115.settg)
	e6:SetOperation(c7449115.setop)
	c:RegisterEffect(e6)
end
function c7449115.eqlimit(e,c)
	return c:IsRace(RACE_INSECT)
end
function c7449115.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c7449115.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c7449115.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7449115.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c7449115.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c7449115.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c7449115.costfilter(c)
	return c:IsCode(7449105) and c:IsAbleToGraveAsCost()
end
function c7449115.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c7449115.costfilter,tp,LOCATION_DECK,0,nil)
	if #g~=0 and Duel.SelectYesNo(tp,aux.Stringid(7449115,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c7449115.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DIRECT_ATTACK)
	ec:RegisterEffect(e0,true)
	local _,res=ec:GetAttackableTarget()
	e0:Reset()
	if chk==0 then return ec:IsAttackPos() end
end
function c7449115.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DIRECT_ATTACK)
	ec:RegisterEffect(e0,true)
	--local _,res=ec:GetAttackableTarget()
	if ec:IsDefensePos() then return end-- or not res
	Duel.CalculateDamage(ec,nil,true)
	e0:Reset()
end
function c7449115.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c7449115.damval(e)
	local c=e:GetHandler()
	if c:GetFlagEffect(7449115)==0 then
		c:RegisterFlagEffect(7449115,RESET_PHASE+PHASE_BATTLE_STEP,0,1)
	end
	return 1
end
function c7449115.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(7449115)~=0 then
		c:ResetFlagEffect(7449115)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if Duel.Damage(1-tp,200,REASON_EFFECT)~=0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(7449115,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(tc))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(-1000)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if not tc:IsDefenseAbove(1) then Duel.SendtoGrave(tc,REASON_EFFECT) end
		end
	end
end
function c7449115.setcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and ev==200
end
function c7449115.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c7449115.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
