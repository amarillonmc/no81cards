--冰结界的还零龙 光枪龙
function c98920039.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920039,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920039)
	e1:SetCost(c98920039.cost)
	e1:SetTarget(c98920039.target)
	e1:SetOperation(c98920039.operation)
	c:RegisterEffect(e1)
--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920039,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98930039)
	e2:SetCondition(c98920039.spcon)
	e2:SetTarget(c98920039.sptg)
	e2:SetOperation(c98920039.spop)
	c:RegisterEffect(e2)
end
function c98920039.costfilter(c,e,tp)
	if c:IsLocation(LOCATION_HAND) then
		return c:IsDiscardable() and c:IsAbleToRemoveAsCost() 
	end
end
function c98920039.fselect(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)<=1
end
function c98920039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920039.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	local rt=Duel.GetTargetCount(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(c98920039.costfilter,tp,LOCATION_HAND,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=g:SelectSubGroup(tp,c98920039.fselect,false,1,rt)
	e:SetLabel(cg:GetCount())
	local tc=cg:Filter(Card.IsLocation,nil,LOCATION_REMOVED):GetFirst()
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
end
function c98920039.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,ct,0,0)
end
function c98920039.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then
		Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c98920039.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsPreviousLocation(LOCATION_MZONE) and rp==1-tp and c:IsPreviousControler(tp)
end
function c98920039.spfilter(c,e,tp)
	if not (c:IsCode(50321796) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else
		return Duel.GetMZoneCount(tp)>0
	end
end
function c98920039.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920039.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c98920039.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920039.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local res=Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		if res then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(3300)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
		local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if dg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.ChangePosition(dg,POS_FACEDOWN_DEFENSE)
		end 
   end				
end
