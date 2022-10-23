--铠甲炮击
function c67200044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200044+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c67200044.target)
	e1:SetOperation(c67200044.activate)
	c:RegisterEffect(e1)	
end
function c67200044.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) 
end
function c67200044.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c67200044.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200044.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c67200044.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local lg=g:GetFirst():GetLinkedGroup()
	lg:Merge(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,lg,lg:GetCount(),0,0)
end
function c67200044.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lg=tc:GetLinkedGroup()
	lg:Merge(tc)
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(lg,REASON_EFFECT)
	end
end