--治安战警队 风魔小夜丸 
function c98920055.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK),2,2)
	c:EnableReviveLimit()
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTarget(c98920055.distg)
	c:RegisterEffect(e2)
   --cannot be used as material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c98920055.linklimit)
	e3:SetTarget(c98920055.matlimit)
	c:RegisterEffect(e3)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920055,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98920055.descon)
	e3:SetTarget(c98920055.destg)
	e3:SetOperation(c98920055.desop)
	c:RegisterEffect(e3)
end
function c98920055.linklimit(e,c)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer())
end
function c98920055.matlimit(e,c)
	return c:IsType(TYPE_LINK)
end
function c98920055.rmfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c98920055.distg(e,c)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c98920055.rmfilter,1,nil,e:GetHandlerPlayer())
end
function c98920055.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsFaceup() and tc:IsSetCard(0x156) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c98920055.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c98920055.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end