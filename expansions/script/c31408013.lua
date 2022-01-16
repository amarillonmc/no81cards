local m=31408013
local cm=_G["c"..m]
cm.name="新生的神欲"
if not pcall(function() require("expansions/script/c31408000") end) then require("expansions/script/c31408000") end
function cm.initial_effect(c)
	Seine_SLM.STset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.lktg)
	e1:SetOperation(cm.lkop)
	c:RegisterEffect(e1)
end
function cm.matfilter(c)
	return c:IsFaceup()
end
function cm.lkfilter(c,mg)
	return c:IsSetCard(0x1313) and c:IsLinkSummonable(mg)
end
function cm.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_ONFIELD,0,nil)
		local ct=Duel.GetCurrentChain()
		if ct>0 then
			mg:AddCard(e:GetHandler())
		end
		return Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=Duel.GetCurrentChain()
	if ct<2 and mg:IsContains(c) then
		mg:RemoveCard(c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=tg:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,mg)
	end
end