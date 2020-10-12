function c82228531.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82228531)   
	e1:SetOperation(c82228531.activate)  
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228531,0))  
	e2:SetCategory(CATEGORY_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetCountLimit(1,82218531)
	e2:SetCost(c82228531.cost1)
	e2:SetTarget(c82228531.sumtg)  
	e2:SetOperation(c82228531.sumop)  
	c:RegisterEffect(e2) 
	--draw  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82228531,1))  
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)  
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetCountLimit(1,82208531)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(c82228531.cost2)
	e3:SetTarget(c82228531.drtg)  
	e3:SetOperation(c82228531.drop)  
	c:RegisterEffect(e3)  
end   
function c82228531.thfilter1(c)  
	return c:IsType(TYPE_MONSTER) and c:IsCode(82228521) and c:IsAbleToHand()
end  
function c82228531.thfilter2(c)  
	return aux.IsCodeListed(c,82228521) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end  
function c82228531.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(c82228531.thfilter1,tp,LOCATION_DECK,0,nil)  
	local g2=Duel.GetMatchingGroup(c82228531.thfilter2,tp,LOCATION_DECK,0,nil)
	g:Merge(g2)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(82228531,2)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,sg)  
	end  
end 
function c82228531.tgfilter(c)  
	return c:GetMutualLinkedGroupCount()>0 
end   
function c82228531.cost1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(82228531,0))  
end  
function c82228531.sumfilter(c)  
	return c:GetAttack()==1350 and c:IsSummonable(true,nil)  
end  
function c82228531.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228531.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c82228531.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)  
end  
function c82228531.sumop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228531.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then  
		Duel.Summon(tp,tc,true,nil)  
	end   
end  
function c82228531.cost2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(82228531,1))  
end  
function c82228531.drfilter(c,e)  
	return (c:GetAttack()==1350 or c:GetAttack()==1950) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)  
end  
function c82228531.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return false end  
	local g=Duel.GetMatchingGroup(c82228531.drfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228531.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local sg=g:Select(tp,4,4,nil) 
	Duel.SetTargetCard(sg)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,4,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function c82228531.drop(e,tp,eg,ep,ev,re,r,rp)  
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=4 then return end  
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)  
	local g=Duel.GetOperatedGroup()  
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end  
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)  
	if ct==4 then  
		Duel.BreakEffect()  
		Duel.Draw(tp,1,REASON_EFFECT)  
	end  
end  