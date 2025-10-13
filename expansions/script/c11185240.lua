--虹龍·星龙
function c11185240.initial_effect(c)
	c:EnableCounterPermit(0x452)
	c:SetUniqueOnField(1,0,50223345)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x453),1,1)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c11185240.atkval)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(c11185240.atkval2)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1)
	e4:SetCondition(c11185240.ctcon)
	e4:SetTarget(c11185240.cttg)
	e4:SetOperation(c11185240.ctop)
	c:RegisterEffect(e4)
end
function c11185240.ctfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsSummonPlayer(tp)
end
function c11185240.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11185240.ctfilter,1,e:GetHandler(),tp)
end
function c11185240.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x452)
end
function c11185240.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x452,1)
	end
end
function c11185240.atkval(e,c)
	return Duel.GetCounter(c:GetControler(),1,0,0x452)*500
end
function c11185240.atkval2(e,c)
	return math.floor(Duel.GetCounter(c:GetControler(),1,0,0x452)/3)
end