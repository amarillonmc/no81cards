--炼金兽 惊异石像鬼
function c10700079.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ROCK),2,5)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(700)
	e1:SetCondition(c10700079.fatkcon)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCondition(c10700079.daatkcon)
	c:RegisterEffect(e11)
	local e12=e1:Clone()
	e12:SetCondition(c10700079.deatkcon)
	c:RegisterEffect(e12)
	local e13=e1:Clone()
	e13:SetCondition(c10700079.eatkcon)
	c:RegisterEffect(e13)
	local e14=e1:Clone()
	e14:SetCondition(c10700079.latkcon)
	c:RegisterEffect(e14)
	local e15=e1:Clone()
	e15:SetCondition(c10700079.watkcon)
	c:RegisterEffect(e15)
	local e16=e1:Clone()
	e16:SetCondition(c10700079.wiatkcon)
	c:RegisterEffect(e16)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700079,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetCondition(c10700079.fatkcon)
	e4:SetTarget(c10700079.damtg)
	e4:SetOperation(c10700079.damop)
	c:RegisterEffect(e4)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c10700079.wiatkcon)
	c:RegisterEffect(e5)
	--defup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCondition(c10700079.eatkcon)
	e6:SetValue(500)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c10700079.efilter)
	c:RegisterEffect(e1)
end
function c10700079.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c10700079.fatkcon(e)
	return Duel.IsExistingMatchingCard(c10700079.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_FIRE)
end
function c10700079.daatkcon(e)
	return Duel.IsExistingMatchingCard(c10700079.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_DARK)
end
function c10700079.deatkcon(e)
	return Duel.IsExistingMatchingCard(c10700079.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_DEVINE)
end
function c10700079.eatkcon(e)
	return Duel.IsExistingMatchingCard(c10700079.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_EARTH)
end
function c10700079.latkcon(e)
	return Duel.IsExistingMatchingCard(c10700079.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_LIGHT)
end
function c10700079.watkcon(e)
	return Duel.IsExistingMatchingCard(c10700079.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_WATER)
end
function c10700079.wiatkcon(e)
	return Duel.IsExistingMatchingCard(c10700079.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_WIND)
end
function c10700079.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetAttack()/2)
end
function c10700079.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,c:GetAttack()/2,REASON_EFFECT)
	end
end
function c10700079.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end