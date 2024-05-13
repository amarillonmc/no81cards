
--风暴之天气模样
function c10202928.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10202928,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10202928)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c10202928.descon)
	e2:SetTarget(c10202928.destg)
	e2:SetOperation(c10202928.desop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c10202928.eftg)
	e3:SetValue(c10202928.efilter)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10202928,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10202928.econ)
	e4:SetCondition(c10202928.desecon)
	e4:SetTarget(c10202928.desetg)
	e4:SetOperation(c10202928.deseop)
	c:RegisterEffect(e4)
end
function c10202928.cfilter(c)
	return c:IsFaceup() and (c:IsCode(22702055) or c:IsLocation(LOCATION_MZONE) and aux.IsCodeListed(c,22702055))
end
function c10202928.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsExistingMatchingCard(c10202928.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10202928.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10202928.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then Duel.Destroy(tc,REASON_EFFECT) end
end
--2
function c10202928.eftg(e,c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c10202928.efilter(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsControler(1-e:GetHandlerPlayer()) and rc:IsNonAttribute(ATTRIBUTE_WATER)
end
--3
function c10202928.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(10202928)
end
function c10202928.desecon(e,tp,eg,ep,ev,re,r,rp)
	if not c10202928.econ(e,tp,eg,ep,ev,re,r,rp) then return false end
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsFaceup() and tc:GetOriginalLevel()>=0 and tc:IsAttribute(ATTRIBUTE_WATER) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c10202928.desetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c10202928.deseop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end