--樱花落尽
function c65899925.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c65899925.excondition)
	e0:SetDescription(aux.Stringid(65899925,1))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65899925)
	e1:SetTarget(c65899925.target)
	e1:SetOperation(c65899925.operation)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE+CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,65899925+1)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c65899925.sptg)
	e3:SetOperation(c65899925.spop)
	c:RegisterEffect(e3)
end


function c65899925.cfilter(c)
	return c:IsCode(71521025) and c:IsFaceup()
end
function c65899925.excondition(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c65899925.cfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil) or Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD,0)==0
end

function c65899925.filter(c,e,tp)
	return c:IsCode(71521025) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65899925.setfilter(c,e,tp)
	return c:IsCode(63086455,11110218,85698115) and c:IsSSetable() and c:IsFaceupEx() and not c:IsForbidden()
end
function c65899925.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65899925.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c65899925.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65899925.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(c65899925.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65899925,0)) then 
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c65899925.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				if tc and Duel.SSet(tp,tc)~=0 then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(65899925,1))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end

function c65899925.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,1000)
end
function c65899925.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,1000,REASON_EFFECT) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil)
		if sg:GetCount()>0 then
			if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
				if tg:GetCount()>0 then
					if Duel.SendtoGrave(tg,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) then
						Duel.BreakEffect()
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
						local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
						if g:GetCount()>0 then
							Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
						end
					end
				end
			end
		end
	end
end