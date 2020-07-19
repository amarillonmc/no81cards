--狂风凤蝶
local m=14010153
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,2,2)
	c:EnableReviveLimit()
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.tgcost)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
end
function cm.matfilter(c)
	return c:IsLevelBelow(2) and c:IsType(TYPE_EFFECT)
end
function cm.tgcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable() and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,c:GetLevel(),nil)
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgcfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.DiscardHand(tp,cm.tgcfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp)
	local g=Duel.GetOperatedGroup()
	e:SetLabel(g:GetFirst():GetOriginalLevel())
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return true end
	if ct~=0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,ct,PLAYER_ALL,LOCATION_EXTRA)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_EXTRA)
	end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	local ct=e:GetLabel()
	if #g1 + #g2 >=ct then
		local ct1=1
		if #g2<ct then ct1=ct-#g2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g1:Select(tp,ct1,ct,nil)
		local ct1=#tg
		if ct>ct1 then
			tg:Merge(g2:RandomSelect(tp,ct-ct1))
		end
		if #tg>0 then
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.chainop)
	Duel.RegisterEffect(e1,tp)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(aux.FALSE)
end