--轮回六道 通灵术·地狱犬
function c79011452.initial_effect(c)
	aux.AddCodeList(c,79011445)
	--Activate 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79011452,1)) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)   
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(79011445) end,tp,LOCATION_MZONE,0,1,nil) end)
	e1:SetTarget(c79011452.actg)  
	e1:SetOperation(c79011452.acop)
	c:RegisterEffect(e1) 
end 
c79011452.SetCard_Pain_PBLK_Skill=true  
function c79011452.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	e:SetCategory(CATEGORY_TODECK)
	local ch=Duel.GetCurrentChain()  
	if ch>1 and Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)==1-tp then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_NEGATE) 
	end  
end
function c79011452.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) 
		local ch=Duel.GetCurrentChain()
		if ch>1 then
			local p,ct=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER,CHAININFO_CHAIN_COUNT)   
			if p==1-tp and Duel.SelectYesNo(tp,aux.Stringid(79011452,0)) then 
				Duel.NegateEffect(ch-1) 
			end
		end 
	end
end







