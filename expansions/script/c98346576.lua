--帝国的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98346576.spspcon)
	c:RegisterEffect(e1)
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--poschange
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c98346576.postg)
	e3:SetOperation(c98346576.posop)
	c:RegisterEffect(e3)
end
function c98346576.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf7) and not c:IsCode(98346576)
end
function c98346576.spspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98346576.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c98346576.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c98346576.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c98346576.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local g=Duel.GetMatchingGroup(c98346576.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c98346576.posop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c98346576.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	if g1:GetCount()>0 then
		Duel.ChangePosition(g1,POS_FACEDOWN_DEFENSE)
	end
end
