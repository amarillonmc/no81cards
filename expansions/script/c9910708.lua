--远古造物 异齿兽
dofile("expansions/script/c9910700.lua")
function c9910708.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,2)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910708)
	e1:SetTarget(c9910708.destg)
	e1:SetOperation(c9910708.desop)
	c:RegisterEffect(e1)
end
function c9910708.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910708.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c9910708.negcon)
	e1:SetOperation(c9910708.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910708.spfilter(c)
	return c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER) and c:IsSpecialSummonable(0)
end
function c9910708.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,9910708)<1
		and Duel.IsExistingMatchingCard(c9910708.spfilter,tp,LOCATION_HAND,0,1,nil)
end
function c9910708.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9910708)<1 and not Duel.IsChainDisabled(ev) and Duel.SelectYesNo(tp,aux.Stringid(9910708,0)) then
		Duel.Hint(HINT_CARD,0,9910708)
		Duel.NegateEffect(ev)
		Duel.RegisterFlagEffect(tp,9910708,RESET_PHASE+PHASE_END,0,1)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910708.spfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g==0 then return end
		local tc=g:GetFirst()
		Duel.SpecialSummonRule(tp,tc,0)
	end
end
