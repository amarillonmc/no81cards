--银河列车·姬子
function c78310477.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c78310477.spcon)
	e1:SetOperation(c78310477.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,78310477)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c78310477.descost)
	e2:SetTarget(c78310477.destg)
	e2:SetOperation(c78310477.desop)
	c:RegisterEffect(e2)
end
function c78310477.spfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x746) and c:IsLevelAbove(10) and c:IsReleasable() and (ft>0 or c:GetSequence()<5)
end
function c78310477.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c78310477.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c78310477.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c78310477.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Release(g,REASON_COST)
end
function c78310477.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c78310477.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x746) and c:GetColumnGroup():GetCount()>0
end
function c78310477.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c78310477.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78310477.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c78310477.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c78310477.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetColumnGroup():GetCount()>0 then
		local g=tc:GetColumnGroup()
		Duel.Destroy(g,REASON_EFFECT)
	end
end
