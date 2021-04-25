--魔救之掘采
function c19198152.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19198152)
	e1:SetTarget(c19198152.target)
	e1:SetOperation(c19198152.activate)
	c:RegisterEffect(e1)   
--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19198152,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,19198153)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c19198152.condition)
	e3:SetTarget(c19198152.sptg)
	e3:SetOperation(c19198152.spop)
	c:RegisterEffect(e3)
end
--draw 
function c19198152.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
end
function c19198152.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if g:GetCount()>1 and g:IsExists(Card.IsSetCard,1,nil,0x140) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg1=g:FilterSelect(p,Card.IsSetCard,1,1,nil,0x140)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			--local sg2=g:Select(p,1,1,sg1:GetFirst())
			--sg1:Merge(sg2)
			Duel.ConfirmCards(1-p,sg1)
			Duel.SendtoDeck(sg1,nil,0,REASON_EFFECT)
			Duel.SortDecktop(p,p,1)
		else
			local hg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
			Duel.ConfirmCards(1-p,hg)
			local ct=Duel.SendtoDeck(hg,nil,0,REASON_EFFECT)
			Duel.SortDecktop(p,p,ct)
		end
	end
end
--spsu
function c19198152.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsLinkRace(RACE_ROCK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19198152.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=1-tp
end
function c19198152.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19198152.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c19198152.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19198152.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end