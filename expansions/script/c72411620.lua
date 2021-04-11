--卓越爆击
function c72411620.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72411620+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c72411620.condition)
	e1:SetTarget(c72411620.target)
	e1:SetOperation(c72411620.activate)
	c:RegisterEffect(e1)
end
function c72411620.confilter(c,tp)
	return c:IsSetCard(0x5729) and c:IsSetCard(0xa726) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c72411620.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c72411620.confilter,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c72411620.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,nil,0,0)
end
function c72411620.activate(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local dn=1
	if n<=20 then dn=2 end
	if n<=5 then dn=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,dn,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local dg=Duel.Destroy(g,REASON_EFFECT)
		Duel.Damage(1-tp,400*dg,REASON_EFFECT)
	end
end