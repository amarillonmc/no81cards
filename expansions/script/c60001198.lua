--天烛灵之梦降下宛若星火
function c60001198.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--summon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1,60001198) 
	e2:SetTarget(c60001198.smtg) 
	e2:SetOperation(c60001198.smop) 
	c:RegisterEffect(e2) 
	--to deck and draw 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_RELEASE)  
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,10001198)
	e3:SetTarget(c60001198.tddtg) 
	e3:SetOperation(c60001198.tddop) 
	c:RegisterEffect(e3) 
end 
function c60001198.smfil(c) 
	return c:IsSetCard(0x6a5) and c:IsSummonable(true,nil)  
end 
function c60001198.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001198.smfil,tp,LOCATION_HAND,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end 
function c60001198.smop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c60001198.smfil,tp,LOCATION_HAND,0,nil) 
	if g:GetCount()>0 then 
		local sc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.Summon(tp,sc,true,nil)
	end 
end 
function c60001198.tddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end 
function c60001198.tddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()<=0 then return end 
	local sg=g:Select(tp,1,1,nil) 
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then 
	Duel.Draw(tp,1,REASON_EFFECT) 
	end 
end 






