--霜曙龙 塞菲耶尔菲-凝冰
function c9910813.initial_effect(c)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910813)
	e1:SetCost(c9910813.tgcost)
	e1:SetTarget(c9910813.tgtg)
	e1:SetOperation(c9910813.tgop)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910813,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e2:SetCountLimit(1,9910814)
	e2:SetTarget(c9910813.postg)
	e2:SetOperation(c9910813.posop)
	c:RegisterEffect(e2)
end
function c9910813.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fe=Duel.IsPlayerAffectedByEffect(tp,9910802)
	local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsDiscardable() and (fe or b2) end
	if fe and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9910802,0))) then
		Duel.Hint(HINT_CARD,0,9910802)
		fe:UseCountLimit(tp)
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,c)
		g:AddCard(c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
end
function c9910813.tgfilter(c)
	return c:IsSetCard(0x6951) and c:IsAbleToGrave()
end
function c9910813.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910813.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c9910813.setfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x6951) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9910813.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910813.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if sg and Duel.SendtoGrave(sg,REASON_EFFECT)>0 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
			local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910813.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(9910813,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg2=g2:Select(tp,1,1,nil)
				Duel.SSet(tp,sg2)
			end
		end
	end
end
function c9910813.posfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsSummonPlayer(1-tp) and (not e or c:IsRelateToEffect(e))
end
function c9910813.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_MZONE) or c:GetEquipTarget()) and eg:IsExists(c9910813.posfilter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c9910813.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c9910813.posfilter,nil,e,tp)
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)<1 or not c:IsRelateToEffect(e) then return end
	Duel.BreakEffect()
	Duel.Destroy(c,REASON_EFFECT)
end
