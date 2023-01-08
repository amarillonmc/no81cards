--《双份黑历史 小孤独弹唱版》
function c79014034.initial_effect(c)
	aux.AddCodeList(c,79014030)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e1:SetTarget(c79014034.actg) 
	e1:SetOperation(c79014034.acop) 
	c:RegisterEffect(e1) 
	--set 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,79014034) 
	e2:SetCost(c79014034.setcost)
	e2:SetTarget(c79014034.settg) 
	e2:SetOperation(c79014034.setop) 
	c:RegisterEffect(e2) 
	--act in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
	e3:SetCondition(c79014034.actcon)
	c:RegisterEffect(e3)
end 
function c79014034.thfil1(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_SPIRIT) 
end 
function c79014034.musck(c) 
	return c:IsCode(79014036,79014037) 
end 
function c79014034.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c79014034.thfil1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end 
	if not Duel.IsExistingMatchingCard(c79014034.musck,tp,LOCATION_FZONE,0,1,nil) then 
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(79014034,0))
	end 
	local g=Duel.SelectTarget(tp,c79014034.thfil1,tp,LOCATION_MZONE,0,1,1,nil) 
	local g1=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end 
function c79014034.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT) 
	end 
end 
function c79014034.setcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,500) end 
	Duel.PayLPCost(tp,500)
end 
function c79014034.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil,POS_FACEDOWN) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA) 
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0) 
end 
function c79014034.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil,POS_FACEDOWN) 
	if g:GetCount()>0 then 
		local rg=g:RandomSelect(tp,1) 
		if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 and c:IsSSetable() then  
		Duel.SSet(tp,c)
		end 
	end 
end 
function c79014034.actckfil(c) 
	return c:IsFaceup() and c:IsCode(79014030)   
end 
function c79014034.actcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c79014034.actckfil,tp,LOCATION_MZONE,0,1,nil) 
end






