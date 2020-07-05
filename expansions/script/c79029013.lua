--罗德岛·部署-深池的仪式
function c79029013.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,79029014)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c79029013.target)
	e1:SetOperation(c79029013.operation)
	c:RegisterEffect(e1)
	--Cost Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c79029013.costchange)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c79029013.eqlimit)
	c:RegisterEffect(e3)
if not c79029013.global_check then
		c79029013.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)   
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,79029013 and Card.IsType,TYPE_EQUIP+TYPE_SPELL))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c79029013.eqlimit(e,c)
	return c:IsSetCard(0xa900)
end
function c79029013.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xa900) 
end
function c79029013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029013.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029013.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029013.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029013.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EQUIP+TYPE_SPELL)
		e1:SetReset(RESET_EVENT+EVENT_REMOVE)
		e:GetHandler():RegisterEffect(e1)
	Debug.Message("既然你嘱咐过我，我就不会再忽视别人的生命......")
	end
end
function c79029013.costchange(e,re,rp,val)
	if re and re:IsHasType(0x7e0) and re:GetHandler()==e:GetHandler():GetEquipTarget() then
		return 0
	else return val end
end
