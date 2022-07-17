--
function c6160502.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160502,0)) 
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,6160502+EFFECT_COUNT_CODE_OATH)  
	e1:SetOperation(c6160502.activate)  
	c:RegisterEffect(e1) 
	--set  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6160502,1))  
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_PHASE+PHASE_END)   
	e2:SetCountLimit(1) 
	e2:SetCondition(c6160502.setcon) 
	e2:SetTarget(c6160502.settg)  
	e2:SetOperation(c6160502.setop)  
	c:RegisterEffect(e2)  
end 
function c6160502.thfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x616)
end  
function c6160502.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(c6160502.thfilter,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(6160502,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,sg)  
	end  
end  
function c6160502.rccfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x616)  
end  
function c6160502.setcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==tp  
		and Duel.IsExistingMatchingCard(c6160502.rccfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function c6160502.filter(c)  
	return c:IsSetCard(0x616) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end  
function c6160502.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c6160502.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c6160502.filter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectTarget(tp,c6160502.filter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)  
end  
function c6160502.setop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SSet(tp,tc)  
	end  
end  