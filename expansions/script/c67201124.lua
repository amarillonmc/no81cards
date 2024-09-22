--尖晶树之森的猎人 塞勒斯特拉薇
function c67201124.initial_effect(c)
	--revive
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c67201124.spcost2)
	e1:SetTarget(c67201124.sptg2)
	e1:SetOperation(c67201124.spop2)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	c:RegisterEffect(e2) 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c67201124.opcon)
	e3:SetTarget(c67201124.optg)
	e3:SetOperation(c67201124.opop)
	c:RegisterEffect(e3)   
end
function c67201124.tdfilter(c,tp)
	return c:IsSetCard(0x3670) and c:IsFaceupEx() and c:IsAbleToDeckAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c67201124.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67201124.tdfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c67201124.tdfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,2,c,tp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c67201124.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67201124.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67201124.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp)
end
function c67201124.rmfilter(c)
	return not c:IsAbleToRemove()
end
function c67201124.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1) and not eg:IsExists(c67201124.rmfilter,1,nil) and Duel.GetFlagEffect(tp,67201124)==0
	local b2=Duel.GetFlagEffect(tp,67201125)==0 and not eg:IsExists(c67201124.rmfilter,1,nil)
	if chk==0 then return b1 or b2 end
end
function c67201124.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1) and not eg:IsExists(c67201124.rmfilter,1,nil) and Duel.GetFlagEffect(tp,67201124)==0
	local b2=Duel.GetFlagEffect(tp,67201125)==0 and not eg:IsExists(c67201124.rmfilter,1,nil)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201124,1),aux.Stringid(67201124,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201124,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201124,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x3670) and Duel.SelectYesNo(tp,aux.Stringid(67201124,3)) then
			Duel.BreakEffect()
			for tc in aux.Next(eg) do
				if tc:IsCanBeDisabledByEffect(e,false) then
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e3)
					end
				end
			end
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)		
		end  
		Duel.RegisterFlagEffect(tp,67201124,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,67201125,RESET_PHASE+PHASE_END,0,1)
	end
end

