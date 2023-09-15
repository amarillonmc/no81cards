--午夜节日恶鬼
function c87090014.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),4,4,c87090014.lcheck)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c87090014.desrepcon)
	e2:SetTarget(c87090014.tg)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetCondition(c87090014.atkcon)
	e3:SetValue(c87090014.atkval)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c87090014.efilter)
	e5:SetCondition(c87090014.effcon)
	e5:SetLabel(3)
	c:RegisterEffect(e5)
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetCondition(c87090014.effcon1)
	e6:SetTarget(c87090014.sumlimit)
	e6:SetLabel(4)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e7)

	
end
function c87090014.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xafa)
end

function c87090014.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xafa) 
end
function c87090014.desrepcon(e)
	return Duel.IsExistingMatchingCard(c87090014.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,2,nil)
end
function c87090014.tg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c87090014.atkcon(e)
	return Duel.IsExistingMatchingCard(c87090014.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,3,nil)
end
function c87090014.atkval(e,c)
	return c:GetBaseAttack()*2
end
function c87090014.effcon(e)
	return Duel.IsExistingMatchingCard(c87090014.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,4,nil)
end
function c87090014.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c87090014.effcon1(e)
	return Duel.IsExistingMatchingCard(c87090014.filter1,e:GetHandler():GetControler(),LOCATION_SZONE,0,5,nil)
end
function c87090014.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsAttackBelow(1000)
end










