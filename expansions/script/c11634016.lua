--教导祈祷
function c11634016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,11634016) 
	e1:SetCost(c11634016.cost)
	e1:SetTarget(c11634016.target)
	e1:SetOperation(c11634016.activate)
	c:RegisterEffect(e1)
	--copy spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11634016) 
	e2:SetTarget(c11634016.cptg)
	e2:SetOperation(c11634016.cpop)
	c:RegisterEffect(e2) 
	Duel.AddCustomActivityCounter(11634016,ACTIVITY_SPSUMMON,c11634016.counterfilter)
end
function c11634016.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA)
end
function c11634016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11634016,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
	return c:IsLocation(LOCATION_EXTRA) end) 
	Duel.RegisterEffect(e1,tp) 
end
function c11634016.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x145) or c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)) and not c:IsCode(11634016) and c:IsAbleToDeck()
end
function c11634016.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingTarget(c11634016.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c11634016.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c11634016.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) end)
	Duel.RegisterEffect(e1,tp)
end   
function c11634016.cpfil(c)
	return c:IsSetCard(0x145) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToDeckAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c11634016.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11634016.cpfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and e:GetHandler():IsAbleToDeckAsCost() end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,c11634016.cpfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler()):GetFirst()
	local sg=Group.FromCards(e:GetHandler(),tc)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	local te=tc:CheckActivateEffect(true,true,false)
	Duel.ClearTargetCard()
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c11634016.cpop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local te=e:GetLabelObject() 
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject()) 
end






