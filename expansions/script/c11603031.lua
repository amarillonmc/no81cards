--封灵爆裂破
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11603016)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6224) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil):GetClassCount(Card.GetCode)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.plfilter(c,tp)
	return c:CheckUniqueOnField(tp,LOCATION_SZONE) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(11603016)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,e:GetHandler()):GetClassCount(Card.GetCode)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,e:GetHandler())
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	local sg=Duel.GetOperatedGroup():Filter(aux.NecroValleyFilter(s.plfilter),nil,1-tp)
	if #sg>0 and ft>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tg=sg:Select(tp,1,ft,nil)
		for tc in aux.Next(tg) do
			if tc and Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
				local c=e:GetHandler()
				--Treated as a Continuous Spell
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
				tc:RegisterEffect(e1)
				--Add this card to the deck
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(id,2))
				e2:SetCategory(CATEGORY_TODECK)
				e2:SetType(EFFECT_TYPE_IGNITION)
				e2:SetRange(LOCATION_SZONE)
				if tc:IsOriginalSetCard(0x6224) then
					e2:SetCondition(aux.NOT(s.effcon))
				end
				e2:SetCost(s.tdcost)
				e2:SetTarget(s.tdtg)
				e2:SetOperation(s.tdop)
				e2:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
				tc:RegisterEffect(e2)
				if tc:IsOriginalSetCard(0x6224) then
					local e3=e2:Clone()
					e3:SetType(EFFECT_TYPE_QUICK_O)
					e3:SetCode(EVENT_FREE_CHAIN)
					e3:SetCondition(s.effcon)
					c:RegisterEffect(e3)
				end
			end
		end
	end
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	c:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAllTypes(TYPE_CONTINUOUS+TYPE_TRAP) and Duel.IsPlayerAffectedByEffect(tp,11603037)
end