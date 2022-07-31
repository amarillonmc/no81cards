--破碎世界的正义
function c6160405.initial_effect(c)  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),2,3)	
   --change effect  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160405,0))  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c6160405.chcon) 
	e1:SetCost(c6160405.chcost) 
	e1:SetTarget(c6160405.chtg)  
	e1:SetOperation(c6160405.chop)  
	c:RegisterEffect(e1)  
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(64753157,2))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_LEAVE_FIELD)  
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,6160405)  
	e2:SetCondition(c6160405.thcon)   
	e2:SetTarget(c6160405.thtg)  
	e2:SetOperation(c6160405.thop)  
	c:RegisterEffect(e2) 
end
function c6160405.chcon(e,tp,eg,ep,ev,re,r,rp)  
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and rp==1-tp  
end
function c6160405.cfilter(c,g)  
	return g:IsContains(c)
end  
function c6160405.chcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local lg=e:GetHandler():GetLinkedGroup()  
	if chk==0 then return Duel.CheckReleaseGroup(tp,c6160405.cfilter,1,nil,lg) end  
	local g=Duel.SelectReleaseGroup(tp,c6160405.cfilter,1,1,nil,lg)  
	Duel.Release(g,REASON_COST)  
end  
function c6160405.chtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return  Duel.IsPlayerCanDraw(tp,1) end  
end  
function c6160405.chop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Group.CreateGroup()  
	Duel.ChangeTargetCard(ev,g)  
	Duel.ChangeChainOperation(ev,c6160405.repop)  
end  
function c6160405.repop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Draw(tp,1,REASON_EFFECT)  
end  
function c6160405.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)  
end  
function c6160405.thfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:IsLevelBelow(3) and c:IsAbleToHand()
end  
function c6160405.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c6160405.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)  
end  
function c6160405.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c6160405.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  