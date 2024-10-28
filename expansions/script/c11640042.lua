--天龙座流星雨
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)	
end
function s.filter(c,e,tp)
	local op=false
	if c:IsLevel(12) then
		op=Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,c,e,tp)
	else
		op=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,c,e,tp,c:GetLevel())
	end
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and op
end
function s.filter2(c,e,tp,lv)	
	return c:IsSetCard(0x3224) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK,0,1,c,c:GetLevel(),lv)
end
function s.filter3(c,lv1,lv2)
	return c:IsSetCard(0x3224) and c:IsType(TYPE_MONSTER) and (c:IsLevel(lv1+lv2) or c:IsLevel(lv1-lv2) )  and c:IsAbleToHand() and c:IsLevelAbove(1)
end 
--
function s.thfilter2(c,e,tp)
	return c:IsSetCard(0x3224) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(s.thfilter3,tp,LOCATION_DECK,0,1,c,c:GetLevel())
end
function s.thfilter3(c,lv)
	return c:IsSetCard(0x3224) and c:IsType(TYPE_MONSTER) and not c:IsLevel(lv)  and c:IsAbleToHand()
end 

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
			local lv=tc:GetLevel()
			if lv==12 then
				s.op2(e,tp,eg,ep,ev,re,r,rp)
			else
				s.op1(e,tp,eg,ep,ev,re,r,rp,lv)
			end
		end
	end 
end
function s.op1(e,tp,eg,ep,ev,re,r,rp,lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g1:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_DECK,0,1,1,tc,tc:GetLevel(),lv)
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,s.thfilter3,tp,LOCATION_DECK,0,1,1,tc,tc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end