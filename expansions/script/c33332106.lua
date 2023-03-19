--龙之澄炎
function c33332106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetTarget(c33332106.actg)  
	e1:SetOperation(c33332106.acop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCondition(aux.exccon) 
	e2:SetCost(aux.bfgcost) 
	e2:SetTarget(c33332106.thtg) 
	e2:SetOperation(c33332106.thop) 
	c:RegisterEffect(e2) 
end
function c33332106.desfil1(c,e,tp) 
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c33332106.desfil2,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,c)  
end 
function c33332106.desfil2(c) 
	return c:IsFaceup() and c:IsSetCard(0x6567) 
end 
function c33332106.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c33332106.desfil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e,tp) end  
	local g=Duel.SelectTarget(tp,c33332106.desfil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD+LOCATION_EXTRA)
end 
function c33332106.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c33332106.desfil2,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,c) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		if Duel.Destroy(dg,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then 
			Duel.BreakEffect() 
			Duel.Destroy(tc,REASON_EFFECT)  
		end  
	end 
end 
function c33332106.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6567) and c:IsFaceup() 
end 
function c33332106.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c33332106.thfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA) 
end 
function c33332106.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332106.thfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)  
	end 
end 







