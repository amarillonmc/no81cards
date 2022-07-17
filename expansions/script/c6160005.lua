--破碎世界的主教
function c6160005.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e1:SetCondition(c6160005.spcon)  
	e1:SetOperation(c6160005.spop)  
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6160005,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,6160005)
	e2:SetTarget(c6160005.rmtg)
	e2:SetOperation(c6160005.rmop)
	c:RegisterEffect(e2)
end
function c6160005.cfilter(c)  
	return c:IsSetCard(0x616) and c:IsAbleToGraveAsCost()  
end  
function c6160005.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	local g=Duel.GetMatchingGroup(c6160005.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)  
	return g:GetCount()>=2 and ft>-2 and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>-ft  
end  
function c6160005.spop(e,tp,eg,ep,ev,re,r,rp,c)  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	local ct=-ft+1  
	local g=Duel.GetMatchingGroup(c6160005.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)  
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
function c6160005.filter(c,tp)  
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end  
function c6160005.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end  
	if chk==0 then return true end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)  
end  
function c6160005.rmop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)  
	end  
end  