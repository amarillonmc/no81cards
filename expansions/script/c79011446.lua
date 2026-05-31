--轮回六道 万象天引
function c79011446.initial_effect(c)
	aux.AddCodeList(c,79011440)
	--Activate 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79011446,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(c79011446.accon)
	e1:SetTarget(c79011446.actg)
	e1:SetOperation(c79011446.acop)
	c:RegisterEffect(e1) 
end
c79011446.SetCard_Pain_PBLK_Skill=true 
function c79011446.accon(e,tp,eg,ep,ev,re,r,rp)   
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(79011440) end,tp,LOCATION_MZONE,0,1,nil) 
end 
function c79011446.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_GRAVE)
end
function c79011446.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil) 
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(function(c) return c:IsCode(79011447) and c:IsAbleToHand() end,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79011446,0)) then 
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(79011447) and c:IsAbleToHand() end,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)  
		Duel.CreateToken(tp,79011441) 
		if c79011441.excon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(79011441,1)) then 
			c79011441.exop(e,tp,eg,ep,ev,re,r,rp)
		end 
		Duel.CreateToken(tp,79011442) 
		if c79011442.excon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(79011442,1)) then 
			c79011442.exop(e,tp,eg,ep,ev,re,r,rp)
		end 
	end
end
