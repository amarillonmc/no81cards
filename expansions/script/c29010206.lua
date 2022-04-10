--剧团舞台 布莱克拉松古堡
function c29010206.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c29010206.xxtg)
	e2:SetOperation(c29010206.xxop)
	c:RegisterEffect(e2)
end
function c29010206.thfil(c)
	return c:IsSetCard(0x17af) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29010206.gck(g)
	return g:GetClassCount(Card.GetCode)==2 
end
function c29010206.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c29010206.thfil,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(c29010206.gck,2,2) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c29010206.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c29010206.thfil,tp,LOCATION_DECK,0,nil) 
	if g:CheckSubGroup(c29010206.gck,2,2) then 
	local sg=g:SelectSubGroup(tp,c29010206.gck,false,2,2) 
	local tc1=sg:RandomSelect(1-tp,1):GetFirst() 
	local tc2=sg:Filter(aux.TRUE,tc1):GetFirst()
	Duel.SendtoHand(tc1,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc1)
	Duel.SendtoGrave(tc2,REASON_EFFECT)
	end
end










