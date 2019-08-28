--Lost Christmas
function c1008022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96029576,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1008022.target)
	e1:SetOperation(c1008022.activate)
	e1:SetCountLimit(1,1008022+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c1008022.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x320e) and c:GetLeftScale()>=4
end
function c1008022.desfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x320e) and c:GetLeftScale()<=4
end
function c1008022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c1008022.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c1008022.desfilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1008022.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1008022.desfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c1008022.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(sg,REASON_EFFECT)==0 then return end
	local seq=0
	local og=Duel.GetOperatedGroup()
	local tc=og:GetFirst()
	while tc do
		seq=bit.replace(seq,0x1,tc:GetPreviousSequence())
		tc=og:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetLabel(seq*0x10000)
	e1:SetOperation(c1008022.disop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c1008022.disop(e,tp)
	return e:GetLabel()
end