--克里斯汀·罗森塔尔
local m=81011002
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c81000000") end,function() require("script/c81000000") end)
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_REMOVE+TIMING_END_PHASE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,m)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local mg=Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler())
		if chk==0 then return mg:GetCount()>=10 end
		local g=mg:Select(tp,10,10,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)	
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
