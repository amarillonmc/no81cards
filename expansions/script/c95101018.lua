--白雪之魔姬 雪之姬
function c95101018.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c95101018.uqfilter,LOCATION_MZONE)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c95101018.sprcon)
	e1:SetOperation(c95101018.sprop)
	c:RegisterEffect(e1)
end
function c95101018.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local rg=Duel.GetReleaseGroup(tp)
	return (g:GetCount()>0 or rg:GetCount()>0) and g:FilterCount(Card.IsReleasable,nil)==g:GetCount()
end
function c95101018.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Release(g,REASON_COST)
	local atk=#g*2000
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c95101018.efilter)
	e2:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function c95101018.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c95101018.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),95101028) then
		return c:IsCode(95101018)
	else
		return c:IsSetCard(0xbba)
	end
end
