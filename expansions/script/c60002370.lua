--煌炎化我牙
local cm,m,o=GetID()
function cm.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
end

function cm.filter(c)
	return c:IsCode(759393,4376658,76615300,92518817) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spcheck(g)
	return g:GetClassCount(Card.GetCode)==1
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local ft=math.min(3,#g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:SelectSubGroup(tp,cm.spcheck,false,1,ft)
		if #hg>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)>0 and hg:Filter(Card.IsLocation,nil,LOCATION_HAND):FilterCount(Card.IsControler,nil,tp)>0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,tp)
			Duel.ConfirmCards(1-tp,og)
		end
	end
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,759393):RandomSelect(tp,1)
	g1:Merge(Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,4376658):RandomSelect(tp,1))
	g1:Merge(Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,76615300):RandomSelect(tp,1))
	g1:Merge(Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,92518817):RandomSelect(tp,1))
	g1:Merge(Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,48815792):RandomSelect(tp,1))
	if chk==0 then return g1:GetCount()>=5 end
	Duel.SendtoGrave(g1,REASON_RULE)
end

function cm.filter2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end

function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local ft=math.min(3,#g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:SelectSubGroup(tp,cm.spcheck,false,1,ft)
		if #hg>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)>0 and hg:Filter(Card.IsLocation,nil,LOCATION_HAND):FilterCount(Card.IsControler,nil,tp)>0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,tp)
			Duel.ConfirmCards(1-tp,og)
		end
	end
end