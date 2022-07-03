--大群之牙 猎食者
function c79078004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,79078004)
	e1:SetCost(c79078004.thcost)
	e1:SetTarget(c79078004.thtg)
	e1:SetOperation(c79078004.thop)
	c:RegisterEffect(e1)
	c79078004.remove_effect=e1

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,79078004+1500)
	e2:SetCondition(c79078004.condition)
	e2:SetTarget(c79078004.target)
	e2:SetOperation(c79078004.operation)
	c:RegisterEffect(e2)
	
end
c79078004.named_with_Massacre=true
function c79078004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c79078004.thfilter1(c)
	return c.named_with_Massacre and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c79078004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79078004.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetFlagEffect(tp,79078004)==0 end  
	Duel.RegisterFlagEffect(tp,79078004,RESET_CHAIN,0,1) 
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end

function c79078004.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c79078004.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		end
	end
end

function c79078004.thfilter(c,e)
	return c.named_with_Massacre and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79078004.condition(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return re:IsActiveType(TYPE_MONSTER) and race&RACE_FISH>0
end
function c79078004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetFlagEffect(tp,79078004)==0 end  
	Duel.RegisterFlagEffect(tp,79078004,RESET_CHAIN,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function c79078004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79078004.thfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if c:IsRelateToEffect(e) then
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c79078004.thfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) and Duel.SelectYesNo(tp,aux.Stringid(79078004,1)) then  
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end 
	end
end