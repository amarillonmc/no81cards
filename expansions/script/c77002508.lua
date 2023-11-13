--罗刹人·折剑
local m=77002508
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	--Effect 2 
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,0))
	e12:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SUMMON)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCountLimit(1,m)
	e12:SetTarget(cm.tgtg)
	e12:SetOperation(cm.tgop)
	c:RegisterEffect(e12)
end
--Effect 1
--Effect 2
function cm.tgfilter(c)
	return c:IsSetCard(0x3eef) and c:IsAbleToGrave()
end
function cm.sum(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_NORMAL)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local mg=Duel.GetMatchingGroup(cm.sum,tp,LOCATION_HAND,0,nil)
		if #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect() 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local tcc=mg:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,tcc,true,nil)
		end
	end
end 