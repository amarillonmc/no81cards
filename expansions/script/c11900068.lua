--咒缚秘法
function c11900068.initial_effect(c) 
	aux.AddCodeList(c,11900061)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c11900068.actg) 
	e1:SetOperation(c11900068.acop) 
	c:RegisterEffect(e1) 
	--to deck 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,11900068)
	e2:SetCost(c11900068.tdhcost)
	e2:SetTarget(c11900068.tdhtg) 
	e2:SetOperation(c11900068.tdhop) 
	c:RegisterEffect(e2)
end
function c11900068.rifil(c,e,tp,def) 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsType(TYPE_RITUAL) and c:GetDefense()<def 
end 
function c11900068.tdfil(c,e,tp) 
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c11900068.rifil,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetDefense()) 
end 
function c11900068.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11900068.tdfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c11900068.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11900068.tdfil,tp,LOCATION_MZONE,0,nil,e,tp)
	if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sc=g:Select(tp,1,1,nil):GetFirst() 
		local def=sc:GetDefense() 
		if Duel.SendtoDeck(sc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c11900068.rifil,tp,LOCATION_GRAVE,0,1,nil,e,tp,def) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,c11900068.rifil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,def):GetFirst()  
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()  
		end 
	end  
end 
function c11900068.tdhcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST) 
end 
function c11900068.gtdfil(c) 
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() 
end 
function c11900068.tdhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11900068.gtdfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c11900068.gtdfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c11900068.thfil(c) 
	return c:IsAbleToHand() and aux.IsCodeListed(c,11900061) and c:IsType(TYPE_MONSTER)   
end 
function c11900068.tdhop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()  
	local g=Group.FromCards(c,tc):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==2 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==2 and Duel.IsExistingMatchingCard(c11900068.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11900068,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c11900068.thfil,tp,LOCATION_DECK,0,1,1,nil)   
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)  
	end 
end