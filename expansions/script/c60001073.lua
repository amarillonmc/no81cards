--莜莱妮卡 双向岔路
local m=60001073
local cm=_G["c"..m]

function cm.initial_effect(c)
	--spsummon from hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,160001073)
	e3:SetCondition(cm.spcon1)
	e3:SetTarget(cm.sptg1)
	e3:SetOperation(cm.spop1)
	c:RegisterEffect(e3)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
end

function cm.consfilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_MONSTER) and c:IsFaceup() 
end

function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.consfilter,tp,LOCATION_MZONE,0,1,nil)
end

function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function cm.optgfilter(c)
	return c:IsCode(24094653) and c:IsAbleToGrave()
end

function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and
	Duel.GetMatchingGroupCount(cm.optgfilter,tp,LOCATION_DECK,0,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.optgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

function cm.tgtfilter(c)
	return c:IsSetCard(0x46) and c:IsAbleToDeck()
end

function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local sum=Duel.GetMatchingGroupCount(cm.tgtfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,tp,LOCATION_GRAVE)
	if sum>=3 then 
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,nil)
	end
end

function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sum=Duel.GetMatchingGroupCount(cm.tgtfilter,tp,LOCATION_GRAVE,0,nil)
	if sum>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,LOCATION_GRAVE,0,1,sum,nil)
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if g:GetCount()>=3 then
			Duel.Draw(tp,(g:GetCount()-(g:GetCount()%3))/3,REASON_EFFECT)
		end
	end
end
		