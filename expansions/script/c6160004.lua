--破碎世界的恋人
function c6160004.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e1:SetCountLimit(1,6161004+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c6160004.spcon)  
	e1:SetOperation(c6160004.spop)  
	c:RegisterEffect(e1)   
	  --Negate  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetCountLimit(1,6160004)
	e2:SetCondition(c6160004.condition)   
	e2:SetTarget(c6160004.target)  
	e2:SetOperation(c6160004.operation)  
	c:RegisterEffect(e2)   
end
function c6160004.cfilter(c)  
	return c:IsSetCard(0x616) and c:IsAbleToGraveAsCost()  
end  
function c6160004.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	local g=Duel.GetMatchingGroup(c6160004.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)  
	return g:GetCount()>=2 and ft>-2 and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>-ft  
end  
function c6160004.spop(e,tp,eg,ep,ev,re,r,rp,c)  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	local ct=-ft+1  
	local g=Duel.GetMatchingGroup(c6160004.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)  
	local sg=nil  
	if ft<=0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
		sg=g:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)  
		if ct<2 then  
			g:Sub(sg)  
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
			local sg1=g:Select(tp,2-ct,2-ct,nil)  
			sg:Merge(sg1)  
		end  
	else  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
		sg=g:Select(tp,2,2,nil)  
	end  
	Duel.SendtoGrave(sg,REASON_COST)  
end  
function c6160004.filter(c,tp)  
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c6160004.condition(e,tp,eg,ep,ev,re,r,rp)  
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end  
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)  
	return g and g:IsExists(c6160004.filter,1,nil,tp)  
		and Duel.IsChainNegatable(ev)  
end  
function c6160004.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function c6160004.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
	Duel.Destroy(eg,REASON_EFFECT)  
	end  
end  