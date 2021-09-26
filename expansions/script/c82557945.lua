--创星钢战-终极超重神
function c82557945.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),9,5)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--disable search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c82557945.con1)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	c:RegisterEffect(e3)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xfe,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetTarget(c82557945.rmtg)
	e2:SetCondition(c82557945.con2)
	c:RegisterEffect(e2)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82557945,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82557945)
	e1:SetTarget(c82557945.target)
	e1:SetOperation(c82557945.operation)
	c:RegisterEffect(e1)
end
function c82557945.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetCount()>=3
end
function c82557945.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c82557945.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetCount()>=4
end
function c82557945.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsCanOverlay() and c:IsFaceup()
end
function c82557945.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c82557945.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(c82557945.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c82557945.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c82557945.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end