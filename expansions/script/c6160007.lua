--破碎世界的死神
function c6160007.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6160007,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,6160007)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c6160007.target)
	e1:SetOperation(c6160007.operation)
	c:RegisterEffect(e1)
end
function c6160007.thfilter(c)  
	return c:IsSetCard(0x616) and c:IsAbleToHand() and not c:IsCode(6160007) 
end
function c6160007.fselect(g)
	return g:IsExists(c6160007.fcheck,1,nil,g)
end
function c6160007.fcheck(c,g)
	return c:IsAbleToHand() and g:IsExists(c6160007.fcheck2,1,c)
end
function c6160007.fcheck2(c)
	return c:IsAbleToRemove()
end
function c6160007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c6160007.thfilter,tp,LOCATION_GRAVE,0,nil)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(c6160007.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c6160007.fselect,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,tp,LOCATION_GRAVE)
end
function c6160007.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c6160007.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:FilterCount(Card.IsRelateToEffect,nil,e)<2 or not g:IsExists(c6160007.fcheck,1,nil,g) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,c6160007.fcheck,1,1,nil,g)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.Remove(g-sg,nil,REASON_EFFECT)
	end
end
function c6160007.splimit(e,c)
	return not c:IsSetCard(0x616)
end