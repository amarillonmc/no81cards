--龙门·近卫干员-陈
function c79029025.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c79029025.ffilter,3,79029063,false)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c79029025.destg)
	e1:SetOperation(c79029025.desop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c79029025.efilter)
	e2:SetCondition(c79029025.imcon)
	c:RegisterEffect(e2)
	--disable search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	c:RegisterEffect(e3)
	--double atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c79029025.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c79029025.imfilter(c)
	return c:IsSetCard(0xa900)
end
function c79029025.filter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c79029025.ffilter(c)
	return c:IsFusionType(TYPE_RITUAL+TYPE_XYZ+TYPE_SYNCHRO+TYPE_LINK) and c:IsSetCard(0xa900)
end
function c79029025.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local x=e:GetHandler():GetMaterialCount()
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,x,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c79029025.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg then
		local g=tg:Filter(Card.IsRelateToEffect,nil,e)
		local a=g:GetCount()
		if g:GetCount()>0 then
			Duel.Destroy(g,nil,REASON_EFFECT)
			Duel.Damage(1-tp,a*600,REASON_EFFECT)
		end
	end
end
function c79029025.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c79029025.imfilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end