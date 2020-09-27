--ダイナミスト・ハウリング
function c500001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c500001.target)
	e1:SetOperation(c500001.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500001,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,500001)
	e2:SetCost(c500001.cost)
	e2:SetOperation(c500001.operation)
	c:RegisterEffect(e2)
end
function c500001.costfilter(c)
	return ((c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)) or (c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS))) and c:IsReleasable()
end
function c500001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500001.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c500001.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,99,nil)
	local ct=Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	e:SetLabel(ct)
end
function c500001.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c500001.setop)
	e1:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e1,tp)
end
function c500001.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500001.setfilter,tp,LOCATION_DECK,0,nil)
	local ft,ct=Duel.GetLocationCount(tp,LOCATION_SZONE),e:GetLabel()
	local ct2=math.min(ft,ct)
	Duel.Hint(HINT_CARD,0,500001)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:Select(tp,1,ct2,nil)
	if sg:GetCount()>0 then
	   Duel.SSet(tp,sg,tp)
	   Duel.ConfirmCards(1-tp,sg)
	end 
end
function c500001.setfilter(c)
	return (c:IsSetCard(0xffac) or c:IsSetCard(0xffad)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c500001.rfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsReleasable()
end
function c500001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500001.rfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_DECK)
end
function c500001.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c500001.rfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RELEASE)
	end
end