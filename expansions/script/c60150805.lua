--爱莎-平安夜
function c60150805.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60150805.spcon)
	e1:SetCost(c60150805.spcost)
	e1:SetTarget(c60150805.sptg)
	e1:SetOperation(c60150805.spop)
	c:RegisterEffect(e1)
	--素材
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c60150805.efcon)
	e3:SetOperation(c60150805.efop)
	c:RegisterEffect(e3)
end
function c60150805.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return ep~=tp and Duel.GetTurnPlayer()==tp and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c60150805.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(60150805)==0 end
	e:GetHandler():RegisterFlagEffect(60150805,RESET_CHAIN,0,1)
end
function c60150805.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local g=Duel.GetMatchingGroup(c60150805.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE+CATEGORY_TOGRAVE,g,1,0,0)
end
function c60150805.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP) then
			Duel.BreakEffect()
			local c=e:GetHandler()
			local g=Duel.GetMatchingGroup(c60150805.filter,tp,0,LOCATION_ONFIELD,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150805,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150805,0))
				local sg=g:Select(tp,1,1,nil)
				local tc=sg:GetFirst()
				if tc:IsAbleToRemove() and tc:IsAbleToGrave() then
					if Duel.SelectYesNo(tp,aux.Stringid(60150805,1)) then
						Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
					else
						Duel.SendtoGrave(tc,REASON_EFFECT)
					end
				elseif not tc:IsAbleToRemove() and tc:IsAbleToGrave() then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				elseif tc:IsAbleToRemove() and not tc:IsAbleToGrave() then
					Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
				end
			end
		end
	end
end
function c60150805.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c60150805.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(60150805,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c60150805.con)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_LEAVE)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
function c60150805.con(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end