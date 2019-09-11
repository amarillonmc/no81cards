--『幻胧月睨』
function c11200026.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetValue(1)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200026+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11200026.tg1)
	e1:SetOperation(c11200026.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_SET_CONTROL)
	e4:SetCondition(c11200026.con4)
	e4:SetValue(c11200026.val4)
	c:RegisterEffect(e4)
--
	if not c11200026.global_check then
		c11200026.global_check=true
		local e5=Effect.GlobalEffect()
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAINING)
		e5:SetCondition(c11200026.con5)
		e5:SetOperation(c11200026.op5)
		Duel.RegisterEffect(e5,0)
	end
--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_EQUIP)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(c11200026.op6)
	c:RegisterEffect(e6)
--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e7:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e7)
--
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_EQUIP)
	e8:SetCode(EFFECT_CHANGE_RACE)
	e8:SetValue(RACE_BEAST)
	c:RegisterEffect(e8)
--
end
--
c11200026.xig_ihs_0x132=1
--
function c11200026.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
--
function c11200026.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--
function c11200026.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),11200026)<1
end
--
function c11200026.val4(e,c)
	return e:GetHandlerPlayer()
end
--
function c11200026.con5(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER)
		and not (rc.xig_ihs_0x132 or rc:IsCode(11200019))
end
--
function c11200026.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,11200026,RESET_PHASE+PHASE_END,0,1)
end
--
function c11200026.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetFirst()~=c then return end
	local tc=c:GetEquipTarget()
	if not tc then return end
	local e6_1=Effect.CreateEffect(c)
	e6_1:SetType(EFFECT_TYPE_SINGLE)
	e6_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6_1:SetCode(EFFECT_CHANGE_CODE)
	e6_1:SetRange(LOCATION_MZONE)
	e6_1:SetLabelObject(c)
	e6_1:SetValue(11200019)
	e6_1:SetCondition(c11200026.con6_1)
	tc:RegisterEffect(e6_1)
	local e6_2=Effect.CreateEffect(c)
	e6_2:SetType(EFFECT_TYPE_SINGLE)
	e6_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e6_2:SetValue(1)
	e6_2:SetLabelObject(c)
	e6_2:SetCondition(c11200026.con6_2)
	tc:RegisterEffect(e6_2)
	local e6_3=Effect.CreateEffect(c)
	e6_3:SetType(EFFECT_TYPE_SINGLE)
	e6_3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6_3:SetCode(11200026)
	e6_3:SetRange(LOCATION_MZONE)
	e6_3:SetLabelObject(c)
	e6_3:SetCondition(c11200026.con6_2)
	c:RegisterEffect(e6_3)
end
--
function c11200026.con6_1(e)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false end
end
--
function c11200026.con6_2(e)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	local p=e:GetLabelObject():GetControler()
	if g:IsContains(e:GetLabelObject()) then
		return c:IsControler(p) and c:GetOwner()~=p
			and not e:GetLabelObject():IsDisabled()
	else return false end
end
--
