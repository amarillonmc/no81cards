--大群之足 巢涌者
function c79078005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,79078005)
	e1:SetCost(c79078005.thcost)
	e1:SetTarget(c79078005.thtg)
	e1:SetOperation(c79078005.thop)
	c:RegisterEffect(e1)
	c79078005.remove_effect=e1

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,79078005+1500)
	e2:SetCondition(c79078005.condition)
	e2:SetTarget(c79078005.target)
	e2:SetOperation(c79078005.operation)
	c:RegisterEffect(e2)
end
c79078005.named_with_Massacre=true
function c79078005.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function c79078005.filter(c)
	return c:IsCode(79078007) and c:IsAbleToHand()
end

function c79078005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79078005.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,79078005)==0 end  
	Duel.RegisterFlagEffect(tp,79078005,RESET_CHAIN,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c79078005.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79078005.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c79078005.thfilter(c,e)
	return c.named_with_Massacre and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79078005.condition(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return re:IsActiveType(TYPE_MONSTER) and race&RACE_FISH>0
end
function c79078005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetFlagEffect(tp,79078005)==0 end  
	Duel.RegisterFlagEffect(tp,79078005,RESET_CHAIN,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function c79078005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79078005.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c79078005.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),e,tp) and Duel.SelectYesNo(tp,aux.Stringid(79078005,1)) then  
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end 
end