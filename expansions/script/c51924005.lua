--暗月雕像/已腐蚀
function c51924005.initial_effect(c)
	aux.AddCodeList(c,51924003)
	c:SetSPSummonOnce(51924005)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c51924005.spcon)
	e1:SetOperation(c51924005.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3256))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(aux.dsercon)
	e4:SetOperation(c51924005.desop)
	c:RegisterEffect(e4)
	--redirect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(c51924005.recon)
	e5:SetValue(LOCATION_DECK)
	c:RegisterEffect(e5)
	--summon count
	Duel.AddCustomActivityCounter(51924005,ACTIVITY_SPSUMMON,c51924005.counterfilter)
end
function c51924005.counterfilter(c)
	return not c:IsLevelAbove(4)
end
function c51924005.spfilter(c,fc,tp)
	return c:IsFusionCode(51924003) and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0 and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function c51924005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCustomActivityCount(51924005,tp,ACTIVITY_SPSUMMON)>0 and Duel.CheckReleaseGroup(tp,c51924005.spfilter,1,nil,c,tp)
end
function c51924005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c51924005.spfilter,1,1,nil,c,tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c51924005.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c51924005.recon(e)
	return e:GetHandler():IsFaceup()
end
