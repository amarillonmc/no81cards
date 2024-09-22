--银枝-荆冠芳勋-
function c60010078.initial_effect(c)
	aux.AddCodeList(c,60010029)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,60010078)
	e1:SetCondition(c60010078.spcon)
	e1:SetTarget(c60010078.sptg)
	e1:SetOperation(c60010078.spop)
	c:RegisterEffect(e1)
	--target/atk protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c60010078.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c60010078.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c60010078.operation)
	c:RegisterEffect(e4)
end
function c60010078.cfilter(c,tp,rp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and rp==1-tp and c:IsReason(REASON_EFFECT) or (Duel.IsPlayerAffectedByEffect(tp,60010139) and c:IsReason(REASON_BATTLE))
end
function c60010078.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(60010029,tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and eg:IsExists(c60010078.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function c60010078.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60010078.tgfilter(c)
	return aux.IsCodeListed(c,60010029) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60010078.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c60010078.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetOwnerPlayer(tp)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
		if Duel.IsExistingMatchingCard(c60010078.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60010078,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=Duel.SelectMatchingCard(tp,c60010078.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end
function c60010078.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c60010078.atlimit(e,c)
	return c~=e:GetHandler()
end
function c60010078.tglimit(e,c)
	return c~=e:GetHandler()
end
function c60010078.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
