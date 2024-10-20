--#鬼马精灵六出花
function c28322401.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--synchro?
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(c28322401.target)
	e1:SetOperation(c28322401.activate)
	c:RegisterEffect(e1)
end
function c28322401.alfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x287) and c:IsReleasableByEffect() and c:IsLevel(4) and 
	Duel.IsExistingTarget(c28322401.rlfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,c)
end
function c28322401.rlfilter(c,e,tp,mc)
	return c:IsPosition(POS_FACEDOWN) and c:IsReleasableByEffect() and 
	Duel.IsExistingMatchingCard(c28322401.syfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c,mc))
end
function c28322401.syfilter(c,e,tp,mg)
	return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsType(TYPE_SYNCHRO)
end
function c28322401.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c28322401.alfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c28322401.alfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectTarget(tp,c28322401.rlfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g,e,tp,g:GetFirst())
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c28322401.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g~=2 then return end
	if Duel.Release(g,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c28322401.syfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil):GetFirst()
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local dam=sc:GetAttack()
			if sc:GetAttack()<sc:GetDefense() then dam=sc:GetDefense() end
			local lp=Duel.GetLP(tp)
			Duel.SetLP(tp,lp-dam)
			if Duel.GetLP(tp)<=8000 then
				Duel.BreakEffect()
				Duel.Release(sc,REASON_EFFECT)
			end
		end
	end
end
