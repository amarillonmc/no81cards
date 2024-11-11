--天与暴君 伏黑甚尔
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,s.matfilter,2,99)
	c:EnableReviveLimit()
	--summon success
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(s.sumsuc)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.damcon)
	c:RegisterEffect(e3)
	--immume
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
	--indes battle
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(s.indes)
	c:RegisterEffect(e5)
end
function s.matfilter(c)
	return not (c:IsLinkType(TYPE_EFFECT) or c:IsLinkType(TYPE_TOKEN))
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(id,0))
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetAttackableTarget()
	if chk==0 then return #g>0 end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
	local g=c:GetAttackableTarget()
	if g and #g>0 then
	local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
		Duel.CalculateDamage(c,tc)
		end
		local bc=Duel.GetAttackTarget()
			if bc and bc:IsRelateToBattle() and bc:IsFaceup() then
			Duel.Hint(HINT_CARD,0,id)
			Duel.Damage(1-tp,bc:GetBaseAttack(),REASON_EFFECT)
			end
		end
	end
end
function s.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsAttackAbove(3000) and c:IsFaceup()
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
	else return te:IsActiveType(TYPE_MONSTER) and te:IsActivated() and te:GetOwner()~=e:GetOwner() end
end
function s.indes(e,c)
	return c:IsType(TYPE_EFFECT)
end