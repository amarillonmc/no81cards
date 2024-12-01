local m=11223404
local cm=_G["c"..m]
cm.name="妖域血奴"
function cm.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.condition)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
end
--Special Summon
function cm.tdfilter(c)
	return c:IsCode(m) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if ct>0 then
			Duel.ShuffleDeck(tp)
			Duel.Draw(1-tp,1,REASON_EFFECT)
			if ct==2 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
--Special Summon
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.filter(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
	if ft>1 and g:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.SpecialSummonStep(g:GetNext(),0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end