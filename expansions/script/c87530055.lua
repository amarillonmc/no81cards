local m=87530055
local cm=_G["c"..m]
cm.name="萝拉之虫惑魔"
function cm.initial_effect(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_DRAW_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.srcon)
	e1:SetCost(cm.srcost)
	e1:SetTarget(cm.srtg)
	e1:SetOperation(cm.srop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_DRAW_PHASE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.srcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
end
function cm.srcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or (Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_DRAW)
end
function cm.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	local res=0
	if c:IsLocation(LOCATION_GRAVE) then res=1 end
	e:SetLabel(res)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function cm.srfilter(c)
	local b1=c:IsSetCard(0x108a) and c:IsType(TYPE_MONSTER)
	local b2=c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89)
	return (b1 or b2) and c:IsAbleToHand()
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsLocation(LOCATION_HAND)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil) and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local res=e:GetLabel()
		if res==1 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,aux.ExceptThisCard(e)) then
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,aux.ExceptThisCard(e))
			if #sg>0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			end
		end
	end
end
function cm.dfilter(c,tp)
	return c:IsSetCard(0x108a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.dfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.efilter(e,te)
	local c=te:GetHandler()
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89)
end