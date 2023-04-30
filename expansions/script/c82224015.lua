function c82224015.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,82224015+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c82224015.activate)  
	c:RegisterEffect(e1)  
	--to grave  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82224015,1))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1)  
	e2:SetTarget(c82224015.tgtg)  
	e2:SetOperation(c82224015.tgop)  
	c:RegisterEffect(e2)  
end
function c82224015.thfilter(c)  
	return c:IsSetCard(0xdf) and c:IsAbleToGrave()  
end  
function c82224015.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(c82224015.thfilter,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(82224015,0)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SendtoGrave(sg,REASON_EFFECT)   
	end  
end  
 
function c82224015.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()  
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,c)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function c82224015.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetOperation(c82224015.actop)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
	local tc=Duel.GetFirstTarget()  
	if not tc:IsRelateToEffect(e) then return end  
	Duel.BreakEffect()  
	Duel.Destroy(tc,REASON_EFFECT)  
end  
function c82224015.actop(e,tp,eg,ep,ev,re,r,rp)  
	local rc=re:GetHandler()  
	if re:IsActiveType(TYPE_MONSTER) then  
		Duel.SetChainLimit(c82224015.chainlm)  
	end  
end  
function c82224015.chainlm(e,rp,tp)  
	return tp==rp  
end  