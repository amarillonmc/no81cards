--暗金教
local m=10419913
local cm=_G["c"..m]
cm.named_with_Kabal=1
function cm.Kabal(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kabal
end
function cm.Potion(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Potion
end

function cm.initial_effect(c)
	--spsummon (self)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	--e2:SetCost(cm.cost)
	e2:SetCondition(cm.condition1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	--draw
	--local e5=Effect.CreateEffect(c)
	--e5:SetCategory(CATEGORY_DRAW)
	--e5:SetDescription(aux.Stringid(m,1))
	--e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e5:SetCode(EVENT_PHASE+PHASE_END)
	--e5:SetRange(LOCATION_MZONE)
	--e5:SetCountLimit(1,m+1)
	--e5:SetCondition(cm.drcon)
	--e5:SetTarget(cm.drtg)
	--e5:SetOperation(cm.drop)
	--c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	local ph=Duel.GetCurrentPhase()
	return not cm.Potion(re:GetHandler())
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)~=0
end
--function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_SPELLCASTER) end
--  local sg=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_SPELLCASTER)
--  Duel.Release(sg,REASON_COST)
--end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_SPELLCASTER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
end
function cm.thfilter(c)
	return cm.Potion(c) and c:IsAbleToHand()
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_SPELLCASTER)
	if sg:GetCount()~=0 and Duel.Release(sg,REASON_EFFECT)>0 and
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,nil)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			sg=sg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=cm[tp]
	if chk==0 then return d>0 and Duel.IsPlayerCanDraw(tp,d) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(d)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,d)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if d>0 then
		Duel.Draw(p,d,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,3,3,nil)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end

