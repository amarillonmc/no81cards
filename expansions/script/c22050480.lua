--悲叹轮回 叛逆的物语
function c22050480.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c22050480.ffilter,5,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckAsCost,LOCATION_MZONE+LOCATION_GRAVE,0,Duel.SendtoGrave,REASON_COST)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c22050480.splimit)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22050480,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c22050480.tdtg)
	e2:SetOperation(c22050480.tdop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xfe,0xff)
	e3:SetValue(LOCATION_DECKSHF)
	e3:SetTarget(c22050480.rmtg)
	c:RegisterEffect(e3)
end
function c22050480.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c22050480.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x1ff8) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c22050480.tdfilter(c)
	return (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c22050480.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c22050480.tdfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22050480.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22050480.tdfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,aux.ExceptThisCard(e))
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c22050480.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end