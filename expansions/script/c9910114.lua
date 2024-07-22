--战车道少女·大吉岭
dofile("expansions/script/c9910100.lua")
function c9910114.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,0,true,nil,true,nil,true,nil)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c9910114.condition)
	e2:SetValue(c9910114.aclimit)
	c:RegisterEffect(e2)
	if not c9910114.global_check then
		c9910114.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c9910114.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9910114.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalRace()==RACE_MACHINE
end
function c9910114.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and rc:IsAttackPos()
		and rc:GetAttackedCount()==0 and rc:GetFlagEffect(9910114)==0
end
function c9910114.atkfilter(c)
	return c:GetAttackedCount()>0 and c:IsFaceup() and c:GetFlagEffect(9910114)==0
end
function c9910114.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910114.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(9910114,RESET_EVENT+RESETS_STANDARD,0,1)
		tc=g:GetNext()
	end
end
