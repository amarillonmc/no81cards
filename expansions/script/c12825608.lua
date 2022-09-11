--铳影-行动代号二
xpcall(function() require("expansions/script/c17035101") end,function() require("script/c17035101") end)
function c12825608.initial_effect(c)
	aux.AddCodeList(c,12825603)
	chiki.c4a71rankup(c,c12825608.filter1,c12825608.filter2,12825608)
	chiki.chikiav(c,EFFECT_FLAG_CARD_TARGET,nil,c12825608.effcon,c12825608.target,c12825608.operation,CATEGORY_REMOVE,12825608,1102)
end
function c12825608.filter1(c)
	return c:IsSetCard(0x4a71) and not c:IsCode(12825603)
end
function c12825608.filter2(c)
	return c:IsCode(12825603)
end
function c12825608.cfilter(c)
	return c:IsFaceup() and c:IsCode(12825603)
end
function c12825608.effcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c12825608.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler())
end
function c12825608.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c12825608.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end