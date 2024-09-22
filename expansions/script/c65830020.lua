--植物娘·火爆辣椒
function c65830020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c65830020.setcon)
	e1:SetTarget(c65830020.target)
	e1:SetOperation(c65830020.activate)
	c:RegisterEffect(e1)
end



function c65830020.filter(c,e,tp)
	return c:IsSetCard(0xa33) and c:IsFaceup()
end
function c65830020.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65830020.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c65830020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65830020.filter1(c,e,tp)
	return c:IsControler(1-tp)
end
function c65830020.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if tc:IsRelateToEffect(e) then
		if tc:IsControler(1-tp) then
		Duel.Destroy(tc,REASON_EFFECT)
		end
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end