function c82221052.initial_effect(c)  
	--pendulum summon  
	aux.EnablePendulumAttribute(c)  
	--to hand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221052,0))  
	e1:SetCategory(CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCountLimit(1,82221052)  
	e1:SetTarget(c82221052.thtg)  
	e1:SetOperation(c82221052.thop)  
	c:RegisterEffect(e1) 
	--special summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221052,1))  
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,82231052)  
	e2:SetTarget(c82221052.sptg)  
	e2:SetOperation(c82221052.spop)  
	c:RegisterEffect(e2) 
end
function c82221052.thfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()  
end  
function c82221052.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221052.thfilter,tp,LOCATION_EXTRA,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)  
end  
function c82221052.thop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221052.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
 
function c82221052.spfilter(c,e,tp)  
	return c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c82221052.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()
	if chkc then return chkc~=c and chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) end  
	if chk==0 then  
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
		if ft<-1 then return false end  
		local loc=LOCATION_ONFIELD  
		if ft==0 then loc=LOCATION_MZONE end  
		e:SetLabel(loc)  
		return Duel.IsExistingTarget(Card.IsFaceup,tp,loc,0,1,c)  
			and Duel.IsExistingMatchingCard(c82221052.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)  
	end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,e:GetLabel(),0,1,1,c)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)  
end  
function c82221052.spop(e,tp,eg,ep,ev,re,r,rp)   
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then  
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local g=Duel.SelectMatchingCard(tp,c82221052.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)  
		if g:GetCount()>0 then  
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
		end  
	end  
end  