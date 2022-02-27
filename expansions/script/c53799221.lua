local m=53799221
local cm=_G["c"..m]
cm.name="偶像组合 RISN"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,function(c)return c:IsLinkType(TYPE_EFFECT) and not c:IsLinkType(TYPE_LINK)end,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(function(e,c)return cm.repfilter(c,e,e:GetHandlerPlayer())end)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,mg)
	return c:IsXyzSummonable(mg) and c:IsRankBelow(6)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=e:GetHandler():GetLinkedGroup()
		return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=c:GetLinkedGroup()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,sg:GetFirst(),mg,1,#mg)
	end
end
function cm.repfilter(c,e,tp)
	return c:IsFaceup() and e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,e,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local g=eg:Filter(cm.repfilter,nil,e,tp)
		Duel.SetTargetCard(g)
		return true
	else return false end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(g) do tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT) end
end
