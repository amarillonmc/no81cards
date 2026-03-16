--闪烁初星 藤田琴音·雨后鸢尾花
function c71201223.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x7121),2,2)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71201223,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,71201223)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c71201223.rmcost)
	e1:SetTarget(c71201223.rmtg)
	e1:SetOperation(c71201223.rmop)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71201223,3))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11201223)
	e3:SetTarget(c71201223.settg)
	e3:SetOperation(c71201223.setop)
	c:RegisterEffect(e3)
end
function c71201223.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x7121) and c:IsAbleToRemoveAsCost()
end
function c71201223.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71201223.costfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71201223.costfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c71201223.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c71201223.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,2,2,nil)
		Duel.HintSelection(sg)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c71201223.cfilter,tp,LOCATION_MZONE,0,3,nil) then
			local tg=Duel.GetMatchingGroup(c71201223.cfilter,tp,LOCATION_MZONE,0,nil)
			local tc=tg:GetFirst()
			while tc do
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(aux.tgoval)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e2)
				tc=tg:GetNext()
			end
		end
	end
end
function c71201223.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7121)
end
function c71201223.pfilter(c,tp)
	return c:IsAllTypes(TYPE_CONTINUOUS+TYPE_SPELL) and c:IsSetCard(0x7121)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c71201223.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c71201223.pfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
end
function c71201223.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c71201223.pfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,71201223) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsRelateToChain()
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.SelectYesNo(tp,aux.Stringid(71201223,4)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end