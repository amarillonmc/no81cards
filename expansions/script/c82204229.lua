local m=82204229
local cm=_G["c"..m]
cm.name="夜刃姬的追忆"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1) 
	--special summon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCode(EVENT_CHAINING)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1,m)  
	e3:SetCondition(cm.thcon)  
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3) 
end
cm.SetCard_01_YeRen=true 
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return re:GetHandler()~=e:GetHandler()
end  
function cm.thfilter(c)  
	return c.SetCard_01_YeRen and not c:IsCode(m) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  