--煌闪之英杰·贝鲁
function c72412590.initial_effect(c)
		--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,5,c72412590.lcheck)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c72412590.immval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c72412590.aclimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c72412590.atktarget)
	c:RegisterEffect(e3)
	--dark
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72412571)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c72412590.datg)
	e1:SetOperation(c72412590.daop)
	c:RegisterEffect(e1)
end
function c72412590.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6727)
end
function c72412590.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActivated()
end
function c72412590.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c72412590.atktarget(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c72412590.dafilter(c)
	return c:GetAttribute()~=ATTRIBUTE_DARK and c:IsFaceup()
end
function c72412590.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72412590.dafilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c72412590.dafilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c72412590.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetTarget(c72412590.datarget)
		e1:SetLabel(tc:GetCode())
		e1:SetValue(ATTRIBUTE_DARK)
		Duel.RegisterEffect(e1,tp)
	end
end
function c72412590.datarget(e,c)
	local code=e:GetLabel()
	return c:IsCode(code) and c:IsType(TYPE_MONSTER)
end