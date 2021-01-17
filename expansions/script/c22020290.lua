--人理之诗 燃烧殆尽的炎之牢
function c22020290.initial_effect(c)
	aux.AddCodeList(c,22020280)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c22020290.cost)
	e1:SetTarget(c22020290.target)
	e1:SetOperation(c22020290.activate)
	c:RegisterEffect(e1)
end
function c22020290.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("给你个绝活！")
end
function c22020290.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsSummonType(SUMMON_TYPE_SPECIAL) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_SPECIAL) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsSummonType,tp,0,LOCATION_MZONE,1,1,nil,SUMMON_TYPE_SPECIAL)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22020290.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020280)
end
function c22020290.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Debug.Message("燃烧殆尽的木之巨人——")
	Debug.Message("燃烧殆尽的炎之牢！")
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		if Duel.IsExistingMatchingCard(c22020290.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22020290,0)) then
			Duel.BreakEffect()
			Duel.Damage(1-tp,2000,REASON_EFFECT)
		end
	end
end
