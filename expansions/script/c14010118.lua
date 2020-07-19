--新生礼赞
local m=14010118
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.disfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,5) and Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,4,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(4)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,4)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(p,cm.disfilter,p,LOCATION_HAND,0,d,d,nil)
	if #g>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)==4 then
			Duel.ShuffleHand(p)
			Duel.BreakEffect()
			if Duel.Draw(p,5,REASON_EFFECT)==0 then return end
			local sg=Duel.GetOperatedGroup():Filter(cm.spfilter,nil,e,tp)
			if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=sg:Select(tp,1,1,nil)
				if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
			end
		end
	end
end