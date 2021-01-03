function c82221064.initial_effect(c)  
	--xyz summon  
	aux.AddXyzProcedure(c,nil,7,2,c82221064.ovfilter,aux.Stringid(82221064,3),4,c82221064.xyzop)  
	c:EnableReviveLimit()  
	--pendulum summon  
	aux.EnablePendulumAttribute(c,false)  
	--to hand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221064,2))  
	e1:SetCategory(CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCountLimit(1)  
	e1:SetTarget(c82221064.rthtg)  
	e1:SetOperation(c82221064.rthop)  
	c:RegisterEffect(e1) 
	--search  
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(82221064,0)) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)  
	e2:SetCost(c82221064.thcost)  
	e2:SetTarget(c82221064.thtg)  
	e2:SetOperation(c82221064.thop)  
	c:RegisterEffect(e2)  
	--pendulum  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221064,1))  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_LEAVE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCondition(c82221064.pencon)  
	e3:SetTarget(c82221064.pentg)  
	e3:SetOperation(c82221064.penop)  
	c:RegisterEffect(e3)  
end  
c82221064.pendulum_level=7  
function c82221064.ovfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x99) and c:IsLevel(7) and c:IsType(TYPE_PENDULUM)
end  
function c82221064.thfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()  
end  
function c82221064.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221064.thfilter,tp,LOCATION_EXTRA,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)  
end  
function c82221064.rthop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221064.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82221064.xyzop(e,tp,chk)  
	if chk==0 then return Duel.GetFlagEffect(tp,82221064)==0 end  
	Duel.RegisterFlagEffect(tp,82221064,RESET_PHASE+PHASE_END,0,1)  
end  
function c82221064.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function c82221064.thfilter(c)  
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()  
end  
function c82221064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221064.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82221064.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221064.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end 
end 
function c82221064.pencon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsFaceup()  
end  
function c82221064.pentg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end  
end  
function c82221064.penop(e,tp,eg,ep,ev,re,r,rp)  
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)  
	end  
end  