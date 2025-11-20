--电次大人最棒！
local m=12866900
local cm=_G["c"..m]
if not Card.GetCardReigistered then
	Card.GetCardReigistered = function ()
									return {}
								end
end
function cm.initial_effect(c)
	aux.AddCodeList(c,12866605)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)  
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)  
end
function cm.hackfilter(e)
	return (e:IsHasType(EFFECT_TYPE_TRIGGER_O) or e:IsHasType(EFFECT_TYPE_TRIGGER_F)) and e:IsHasType(EFFECT_TYPE_SINGLE) and e:GetCode()==EVENT_SPSUMMON_SUCCESS
end
function cm.tdcheck(c,e,tp,eg,ep,ev,re,r,rp,chk)
	if c:IsSummonableCard() or c:IsAttribute(ATTRIBUTE_LIGHT) or not c:IsRace(RACE_FIEND) or not c:IsAbleToDeckOrExtraAsCost() then return false end
	local tab={c:GetCardRegistered(cm.hackfilter,0xf)}
	for _,ge in ipairs(tab) do
		local target=ge:GetTarget()
		if not target or target(e,tp,eg,ep,ev,re,r,rp,0) then
			return true
		end
	end
	return false
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdcheck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdcheck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	local tc=e:GetLabelObject()
	local tab={tc:GetCardRegistered(cm.hackfilter,0xf)}
	local resolve_tab = {}
	local resolve_tab_desc = {}
	for _,ge in ipairs(tab) do
		local target=ge:GetTarget()
		if target(e,tp,eg,ep,ev,re,r,rp,0) then
			local desc=ge:GetDescription() or aux.Stringid(m,3)
			table.insert(resolve_tab_desc, desc)
			table.insert(resolve_tab, ge)
		end
	end
	local op=Duel.SelectOption(tp,table.unpack(resolve_tab_desc))+1
	local te=resolve_tab[op]
	local target=te:GetTarget()
	if target then target(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	if tc:IsCode(12866605) then
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CAN_FORBIDDEN|te:GetProperty())
	else
		e:SetProperty(te:GetProperty())
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		_relate=Card.IsRelateToEffect
		function Card.IsRelateToEffect(card,effect)
			if effect==te then
				return _relate(card,e)
			else
				return _relate(card,effect)
			end
		end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		Card.IsRelateToEffect=_relate
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.thfilter(c)
	return c:IsSetCard(0x9a7c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
	end
end