function c82228525.initial_effect(c)  
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,c82228525.matfilter,1,1)
	--to hand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228525,0))  
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,82228525)  
	e1:SetCondition(c82228525.thcon)  
	e1:SetCost(c82228525.thcost)  
	e1:SetTarget(c82228525.thtg)  
	e1:SetOperation(c82228525.thop)  
	c:RegisterEffect(e1) 
	--att change  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228525,1))  
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,82218525)  
	e2:SetTarget(c82228525.atttg)  
	e2:SetOperation(c82228525.attop)  
	c:RegisterEffect(e2)  
end   
function c82228525.matfilter(c)  
	return c:GetAttack()==1350 and not c:IsCode(82228525)  
end  
function c82228525.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function c82228525.costfilter(c)  
	return c:GetBaseAttack()==1350 and c:IsDiscardable()  
end  
function c82228525.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228525.costfilter,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,c82228525.costfilter,1,1,REASON_DISCARD+REASON_COST)  
end  
function c82228525.thfilter(c)  
	return c:IsSetCard(0x295) and c:IsAbleToHand()  
end  
function c82228525.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228525.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82228525.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228525.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82228525.atttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)  
	local aat=Duel.AnnounceAttribute(tp,1,0xff-e:GetHandler():GetAttribute())  
	e:SetLabel(aat)  
end  
function c82228525.attop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)  
		e1:SetValue(e:GetLabel())  
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1)  
	end  
end