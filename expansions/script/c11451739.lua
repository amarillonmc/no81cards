--漫然溯醒的长夜梦
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x6977)
end
function cm.filter2(c,e,tp)
	return c:IsSetCard(0x6977) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function cm.filter4(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	local g3=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	local g4=Duel.GetMatchingGroup(cm.filter4,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	local b1=g1:CheckSubGroup(aux.dncheck,2,2) and #g3>0
	local b2=#g2>0 and #g4>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g3,1,0,0)
	end
	if s==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g4,1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	if e:GetLabel()==0 and g1:CheckSubGroup(aux.dncheck,2,2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g1:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if #sg>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleDeck(tp)
			local g3=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
			if #g3==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=g3:Select(tp,1,1,nil)
			Duel.SendtoDeck(dg,nil,0,REASON_EFFECT)
		end
	elseif e:GetLabel()==1 and #g2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g2:Select(tp,1,1,nil)
		if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.ShuffleDeck(tp)
			local g4=Duel.GetMatchingGroup(cm.filter4,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil)
			if #g4==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=g4:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.SendtoDeck(dg,nil,0,REASON_EFFECT)
		end
	end
end