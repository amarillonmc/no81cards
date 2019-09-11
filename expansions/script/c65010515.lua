--URBEX HINDER-暴食者
function c65010515.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c65010514.lcheck)
	c:EnableReviveLimit()
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65741786,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65741786)
	e1:SetCondition(c65741786.lkcon)
	e1:SetTarget(c65741786.lktg)
	e1:SetOperation(c65741786.lkop)
	c:RegisterEffect(e1)
end
c65010514.setname="URBEX"
function c65010514.lcfil(c)
	return c.setname=="URBEX"
end
function c65741786.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c65010515.lkfil(c,mc)
	return c:IsLinkSummonable(nil,mc) and c.setname=="URBEX"
end
function c65741786.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local m=0
	if e:GetHandler():GetMutualLinkedGroupCount()>0 then
		
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c65010515.lkfil,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65741786.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c65010515.lkfil,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end