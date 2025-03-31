--放课后五月夕日晖
function c28363720.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c28363720.mfilter,aux.dabcheck,2,99)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c28363720.thcon)
	e1:SetCost(c28363720.thcost)
	e1:SetTarget(c28363720.thtg)
	e1:SetOperation(c28363720.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28363720,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c28363720.cost)
	e2:SetTarget(c28363720.target)
	e2:SetOperation(c28363720.operation)
	c:RegisterEffect(e2)
	if not c28363720.global_check then
		c28363720.global_check=true
		c28363720.summon_code={}
		local ge0=Effect.CreateEffect(c)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetOperation(c28363720.clear)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c28363720.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28363720.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4)
end
function c28363720.clear(e,tp,eg,ep,ev,re,r,rp)
	c28363720.summon_code={}
end
function c28363720.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsFaceup,nil)
	for tc in aux.Next(g) do
		local code=tc:GetCode()
		table.insert(c28363720.summon_code,code)
	end
end
function c28363720.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c28363720.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c28363720.cfilter(c)
	return c:IsSetCard(0x286) and c:IsAbleToGrave() and c:IsAbleToHand()
end
function c28363720.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--local og=e:GetHandler():GetOverlayGroup()
	local ct=e:GetHandler():GetOverlayCount()
	local g=Duel.GetMatchingGroup(c28363720.cfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ct>0 and e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) and #g>=ct end
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	Duel.SetTargetParam(ct)
end
function c28363720.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(c28363720.cfilter,tp,LOCATION_DECK,0,nil)
	if ct<1 or g:GetCount()<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:Select(tp,ct,ct,nil)
	local sg=cg:RandomSelect(1-tp,1)
	cg:Sub(sg)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	if cg:GetCount()>0 then
		Duel.SendtoHand(cg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,cg)
	end
end
function c28363720.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c28363720.thfilter(c)
	if not (c:IsSetCard(0x286) and c:IsAbleToHand()) then return false end
	for _,code in pairs(c28363720.summon_code) do
		if c:IsCode(code) then return true end
	end
	return false
end
function c28363720.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28363720.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c28363720.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28363720.thfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
