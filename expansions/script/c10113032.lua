--杀人机器 DM-9
function c10113032.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10113032.spcon)
	e1:SetOperation(c10113032.spop)
	c:RegisterEffect(e1)	
end
function c10113032.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToDeckAsCost()
end
function c10113032.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10113032.spfilter,c:GetControler(),0,LOCATION_ONFIELD,1,nil)
end
function c10113032.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10113032.spfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end