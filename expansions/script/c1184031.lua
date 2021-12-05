--饮食艺术·苏打水
function c1184031.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c1184031.FusFilter,1,true,true)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c1184031.con2)
	e2:SetOperation(c1184031.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1184031,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c1184031.op3)
	c:RegisterEffect(e3)
--
end
--
function c1184031.FusFilter(c)
	return c:IsAttack(1800) and c:IsLevel(3)
end
--
function c1184031.cfilter2(c,fc)
	return bit.band(c:GetOriginalType(),TYPE_XYZ)~=0
		and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
		and c:IsAbleToGraveAsCost()
		and c:IsFusionSetCard(0x3e12)
		and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function c1184031.con2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c1184031.cfilter2,tp,LOCATION_SZONE,0,1,nil,c)
end
--
function c1184031.op2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c1184031.cfilter2,tp,LOCATION_SZONE,0,1,1,nil,c)
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
--
function c1184031.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,1184031)~=0 then return end
	if not Duel.IsPlayerCanAdditionalSummon(tp) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(1184031,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3e12))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,1184031,RESET_PHASE+PHASE_END,0,1)
end
--
