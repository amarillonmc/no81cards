--赤鸢·折剑
local m=77002505
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	--Effect 2  
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_SUMMON+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCountLimit(1,m+m)
	e12:SetTarget(cm.tg)
	e12:SetOperation(cm.op)
	c:RegisterEffect(e12)   
end
--Effect 1
--Effect 2
function cm.tf(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x3eef)
end
function cm.sum(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_NORMAL)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tf,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tf),tp,LOCATION_GRAVE,0,2,2,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			local mg=Duel.GetMatchingGroup(cm.sum,tp,LOCATION_HAND,0,nil)
			if #mg>0 and #og>=2 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.BreakEffect() 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local tcc=mg:Select(tp,1,1,nil):GetFirst()
				Duel.Summon(tp,tcc,true,nil)
			end
		end
	end 
end