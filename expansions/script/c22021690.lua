--人理之诗 撕裂天际的辉煌之船
function c22021690.initial_effect(c)
	aux.AddCodeList(c,22020940,22025820)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c22021690.con1)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff1))
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c22021690.con2)
	e3:SetOperation(c22021690.chainop)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c22021690.con3)
	e4:SetValue(c22021690.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c22021690.con3)
	e5:SetValue(c22021690.effectfilter)
	c:RegisterEffect(e5)
	--race
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_ONFIELD+LOCATION_HAND,0)
	e6:SetCode(EFFECT_ADD_CODE)
	e6:SetCondition(c22021690.con4)
	e6:SetTarget(c22021690.tgtg)
	e6:SetValue(22025820)
	c:RegisterEffect(e6)
end
function c22021690.cfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,22025820) and c:IsType(TYPE_MONSTER)
end
function c22021690.con1(e)
	return Duel.IsExistingMatchingCard(c22021690.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c22021690.con2(e)
	return Duel.IsExistingMatchingCard(c22021690.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c22021690.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(22025820) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and ep==tp then
		Duel.SetChainLimit(c22021690.chainlm)
	end
end
function c22021690.chainlm(e,rp,tp)
	return tp==rp 
end
function c22021690.con3(e)
	return Duel.IsExistingMatchingCard(c22021690.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
function c22021690.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsCode(22025820) and bit.band(loc,LOCATION_ONFIELD)~=0
end
function c22021690.tgtg(e,c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22021690.con4(e)
	return Duel.IsExistingMatchingCard(c22021690.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,4,nil) and Duel.IsExistingMatchingCard(c22021690.cfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c22021690.cfilter1(c)
	return c:IsFaceup() and c:IsCode(22020940)
end