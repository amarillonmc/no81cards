--咕哒子-未来拓展
function c22022930.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c22022930.spcon)
	e1:SetOperation(c22022930.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022930,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22022930.cost)
	e2:SetTarget(c22022930.tgtg)
	e2:SetOperation(c22022930.tgop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022930,3))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22022930.erecon)
	e3:SetCountLimit(1)
	e3:SetCost(c22022930.erecost)
	e3:SetTarget(c22022930.tgtg)
	e3:SetOperation(c22022930.tgop)
	c:RegisterEffect(e3)
end
function c22022930.spfilter(c)
	return c:IsFaceup() and c:IsCode(22020000) and c:IsRace(RACE_SPELLCASTER)
end
function c22022930.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c22022930.spfilter,1,nil)
end
function c22022930.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c22022930.spfilter,1,1,nil)
	Duel.Hint(HINT_CARD,0,22020000)
	Duel.Release(g,REASON_COST)
	Duel.SelectOption(tp,aux.Stringid(22022930,1))
	Duel.Hint(HINT_CARD,0,22021701)
	Duel.Hint(HINT_CARD,0,22021702)
	Duel.Hint(HINT_CARD,0,22021700)
	Duel.SelectOption(tp,aux.Stringid(22022930,2))
end
function c22022930.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022930.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c22022930.tgfilter(c)
	return c:IsSetCard(0x6ff1) and c:IsAbleToGrave()
end
function c22022930.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22022930.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,0)
		e2:SetValue(c22022930.aclimit)
		e2:SetLabel(g:GetFirst():GetCode())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c22022930.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
function c22022930.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22022930.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22022930.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end