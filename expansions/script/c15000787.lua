local m=15000787
local cm=_G["c"..m]
cm.name="冬之刻证兽·梅利契辛"
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,15000787)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15000788)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.tdfilter(c)
	return c:IsAbleToDeck()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	if g:GetFirst():IsSetCard(0x6f3d) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function cm.spdfilter(c,e,tp)
	return c:IsCode(15000780) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local tc=Duel.GetFirstTarget()
	local x=0
	local b1=tc:IsSetCard(0x6f3d)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and b1 and Duel.IsExistingMatchingCard(cm.spdfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local ag=Duel.SelectMatchingCard(tp,cm.spdfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if ag:GetCount()~=0 then
				Duel.SpecialSummon(ag,0,tp,tp,false,false,POS_FACEUP)
			end
			x=1
		end
	end
	if x==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.splimit(e,c)
	return not (c:IsRace(RACE_BEAST) or c:IsRace(RACE_ROCK))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end