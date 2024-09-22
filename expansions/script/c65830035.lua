--植物娘·大嘴花
function c65830035.initial_effect(c)
	--装备
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65830035)
	e1:SetTarget(c65830035.Target1)
	e1:SetOperation(c65830035.activate1)
	c:RegisterEffect(e1)
end


function c65830035.nbfilter(c)
	return c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT) and c:IsType(TYPE_MONSTER) 
end
function c65830035.Target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c65830035.nbfilter(chkc) and c~=chkc end
	if chk==0 then return Duel.IsExistingTarget(c65830035.nbfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c65830035.nbfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c65830035.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsType(TYPE_MONSTER) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end