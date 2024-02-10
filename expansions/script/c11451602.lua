--破坏剑士的试炼
--21.08.27
local cm,m=GetID()
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
	return c:IsSetCard(0xd6) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_DECK))
end
function cm.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function cm.thfilter(c)
	return c:IsSetCard(0xd7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	if chk==0 then return #g1>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,#g1,0,0)
end
function cm.fselect(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)<=1
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=g:SelectSubGroup(tp,cm.fselect,false,1,3)
	if Duel.Destroy(g1,REASON_EFFECT)>0 then
		local sg=Duel.GetOperatedGroup():Filter(cm.spfilter,nil,e,tp)
		local g2=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
		if #sg>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
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
	if chk==0 then return Duel.CheckReleaseGroup(tp,aux.TRUE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end