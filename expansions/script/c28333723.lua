--沉醉的古之谣 纯白梦想曲
function c28333723.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28333723.cost)
	e1:SetTarget(c28333723.target)
	e1:SetOperation(c28333723.activate)
	c:RegisterEffect(e1)
	--destory
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c28333723.descost)
	e2:SetTarget(c28333723.destg)
	e2:SetOperation(c28333723.desop)
	c:RegisterEffect(e2)
end
function c28333723.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=3000 or Duel.CheckLPCost(tp,2000) end
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,2000) end
end
function c28333723.spfilter(c,e,tp)
	return c:IsSetCard(0x285) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28333723.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local loc=LOCATION_HAND+LOCATION_GRAVE
		if Duel.GetLP(tp)<=3000 then loc=loc+LOCATION_DECK end
		return Duel.IsExistingMatchingCard(c28333723.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c28333723.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if Duel.GetLP(tp)<=3000 then loc=loc+LOCATION_DECK end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28333723.spfilter),tp,loc,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetHandler():IsRelateToChain() then
		--local c=e:GetHandler()
		--local code=c:IsRelateToChain() and c:GetCode() or 0
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(28333723,1))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
		e1:SetOperation(c28333723.regop)
		e1:SetLabel(e:GetHandler():GetCode())
		sc:RegisterEffect(e1)
	end
end
function c28333723.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c28333723.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetPreviousControler()
	local g=Duel.GetMatchingGroup(c28333723.thfilter,p,LOCATION_GRAVE,0,nil,e:GetLabel())
	if c:IsReason(REASON_DESTROY) and #g>0 then
		Duel.Hint(HINT_CARD,0,28333723)
		local tc=g:GetFirst()
		if #g>=2 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
			tc=g:Select(p,1,1,nil):GetFirst()
		end
		Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	e:Reset()
end
function c28333723.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_DESTROY) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c28333723.desfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_SPELL)
end
function c28333723.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28333723.desfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function c28333723.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c28333723.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g~=0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
