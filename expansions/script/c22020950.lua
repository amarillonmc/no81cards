--人理之基 美狄亚
function c22020950.initial_effect(c)
	aux.AddCodeList(c,22020940)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22020950)
	e1:SetCondition(c22020950.spcon)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020950,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,22020951)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c22020950.cost)
	e2:SetTarget(c22020950.tftg)
	e2:SetOperation(c22020950.tfop)
	c:RegisterEffect(e2)
end
function c22020950.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22020950.spfilter(c)
	return c:IsFaceup() and c:IsCode(22020940)
end
function c22020950.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22020950.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22020950.tffilter(c,tp)
	return c:IsCode(22020960) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c22020950.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c22020950.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c22020950.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c22020950.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end