-- 恋爱头脑战-大佛小钵
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12819165)
	--
	aux.AddLinkProcedure(c,nil,2,nil,s.lcheck)
	c:EnableReviveLimit()
	--spsum condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3a73)
end
function s.pfilter(c)
	return c:IsSetCard(0x3a73) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsForbidden()
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.hasstone(c)
	return c:IsCode(12819165) and c:IsFaceup()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_EXTRA,0,1,nil) 
	and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	local g=Duel.GetMatchingGroup(s.pfilter,tp,LOCATION_EXTRA,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	if Duel.IsExistingMatchingCard(s.hasstone,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
		if #sg>0 then 
				Duel.HintSelection(sg)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
			end
	end
end