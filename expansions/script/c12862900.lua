--晴空光行·春日远足
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.ctfilter(c,tp)
	return c:IsSetCard(0x5a76) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsLocation(LOCATION_HAND) and 1 or 0
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft and Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:GetType()==TYPE_SPELL then 
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.ctfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	if #g>0 then 
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(1118)
			e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetCode(EVENT_CHAINING)
			e2:SetRange(LOCATION_SZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetCountLimit(1)
			e2:SetCondition(s.spcon)
			e2:SetTarget(s.sptg)
			e2:SetOperation(s.spop)
			tc:RegisterEffect(e2,true)
		end
	end
	if c:IsRelateToEffect(e) and c:IsSSetable(true) and e:GetLabel()==1 then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
		c:SetCardData(CARDDATA_TYPE,TYPE_SPELL+TYPE_QUICKPLAY)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(s.chop)
		e1:SetLabelObject(c)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffect(id)~=0 then return end
	c:ResetFlagEffect(id)
	c:SetCardData(CARDDATA_TYPE,TYPE_SPELL)
	e:Reset()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.thfilter(c,code)
	return c:IsSetCard(0x5a76) and not c:IsCode(code) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,c:GetCode())
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:Select(tp,1,1,nil)
				if #sg>0 then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
				end
			end
		end
	end
end
