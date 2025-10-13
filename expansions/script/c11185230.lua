--虹龍·源龙
function c11185230.initial_effect(c)
	c:EnableCounterPermit(0x452)
	c:SetUniqueOnField(1,0,50223345)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x453),1,1)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c11185230.damop)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EVENT_MSET)
	c:RegisterEffect(e11)
	local e12=e1:Clone()
	e12:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e12)
	local e13=e1:Clone()
	e13:SetCondition(c11185230.damcon2)
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
	--damage
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_CHAINING)
	e14:SetRange(LOCATION_MZONE)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e14:SetOperation(c11185230.regop)
	c:RegisterEffect(e14)
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e15:SetCode(EVENT_CHAIN_SOLVED)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCondition(c11185230.damcon)
	e15:SetOperation(c11185230.damop)
	c:RegisterEffect(e15)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(3)
	e4:SetCondition(c11185230.ctcon)
	e4:SetTarget(c11185230.cttg)
	e4:SetOperation(c11185230.ctop)
	c:RegisterEffect(e4)
end
function c11185230.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c11185230.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x452)
end
function c11185230.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x452,1)
	end
end
function c11185230.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11185230,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c11185230.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(11185230)~=0
end
function c11185230.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(aux.TRUE,1,c)
end
function c11185230.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,11185230)
	Duel.Recover(tp,100,REASON_EFFECT)
	Duel.Damage(1-tp,100,REASON_EFFECT)
end