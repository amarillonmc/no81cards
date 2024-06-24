local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(s.cptg)
	e1:SetOperation(s.cpop)
	c:RegisterEffect(e1)
end
function s.cpfilter(c,tp)
	if not (c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil) then return false end
	return c:GetActivateEffect():GetOperation() and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:IsCostChecked() and c:IsDiscardable() and Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_MOVE)
	e1:SetLabel(0)
	e1:SetOperation(s.mvop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabel(Duel.GetCurrentChain())
	e2:SetLabelObject(e1)
	e2:SetCondition(s.tdcon)
	e2:SetOperation(s.tdop)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(function(c,tp)return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsLocation(LOCATION_DECK)end,nil,tp)
	local l=e:GetLabel()
	e:SetLabel(l+ct)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==e:GetLabel()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	e:GetLabelObject():Reset()
	e:Reset()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if g:GetCount()<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,ct,ct,nil)
	aux.PlaceCardsOnDeckBottom(tp,sg)
end
