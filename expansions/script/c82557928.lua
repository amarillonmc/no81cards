--登龙钢战-龙神丸
function c82557928.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82557928.psplimit)
	c:RegisterEffect(e1)
	--summon with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82557928,0))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c82557928.ntcon)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82557928,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c82557928.ntcon2)
	c:RegisterEffect(e3)
	--no release
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82557928,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,82557928)
	e4:SetOperation(c82557928.dwop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c82557928.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_MACHINE) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82557928.ntfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x829)
end
function c82557928.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82557928.ntfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c82557928.ntcon2(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c82557928.dwop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82557928,4))
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetTargetRange(LOCATION_HAND,0)
	e7:SetCode(EFFECT_SUMMON_PROC)
	e7:SetRange(LOCATION_MZONE)
	e7:SetReset(RESET_PHASE+PHASE_END)
	e7:SetCondition(c82557928.ntcon3)
	e7:SetTarget(c82557928.nttg3)
	c:RegisterEffect(e7)
end
function c82557928.ntcon3(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c82557928.nttg3(e,c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_MACHINE)
end