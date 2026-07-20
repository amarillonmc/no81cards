--幽魔溶解

local s,id=GetID()
s.named_with_Darkling=1

s.TEMPLE_CODE=40021119

function s.Darkling(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkling
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end

function s.mon_filter(c)
	return s.Darkling(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.temple_filter(c)
	return c:IsCode(s.TEMPLE_CODE) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.mon_filter,tp,LOCATION_DECK,0,1,nil)
		   and Duel.IsExistingMatchingCard(s.temple_filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.mon_filter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(s.temple_filter,tp,LOCATION_DECK,0,nil)
	if #g1>0 and #g2>0 then
		local sg=Group.CreateGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc1=g1:Select(tp,1,1,nil):GetFirst()
		if tc1 then sg:AddCard(tc1) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc2=g2:Select(tp,1,1,nil):GetFirst()
		if tc2 then sg:AddCard(tc2) end
		if #sg==2 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
