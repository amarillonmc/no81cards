--可可莉柯特·地狱尖啸者
local m=33310104
local cm=_G["c"..m]
cm.rssetcode="Cochrot"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.con)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
	--todeck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCountLimit(1,m+100)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetTarget(cm.tdtg)
	e6:SetOperation(cm.tdop)
	c:RegisterEffect(e6)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.thfilter(c)
	return c:IsCode(33310101) and c:IsAbleToHand()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g<=0 or Duel.SendtoHand(g,nil,REASON_EFFECT)<=0 then return end
		Duel.ConfirmCards(1-tp,g)
		local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil)
		if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			rg=rg:Select(tp,1,1,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.con(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.aclimit(e,re,tp)
	return not re:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.tdop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end