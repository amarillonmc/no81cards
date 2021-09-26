--破坏剑士的试炼
--21.08.27
local m=11451602
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:GetOriginalType()&TYPE_MONSTER>0 and c:IsFaceup() and not c:IsSetCard(0xd7)
end
function cm.filter1(c,tp)
	return c:IsSetCard(0xd6) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,1-tp,c)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xd6) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function cm.thfilter(c)
	return c:IsSetCard(0xd6) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #g1>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and g1:IsExists(cm.filter1,1,nil,tp) and #g2>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,#g1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	if Duel.Destroy(g1,REASON_EFFECT)>0 then
		local sg=Duel.GetOperatedGroup():Filter(cm.spfilter,nil,e,tp)
		if #sg>0 then
			local ct=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
			if #sg>ct then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,ct,ct,nil)
			end
			local ft=Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
			local g2=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
			if ft>0 and #g2>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local hg=g2:Select(tp,1,ft,nil)
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hg)
			end
		end
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end