--千夜 天堂武装
function c60150624.initial_effect(c)
	c:SetUniqueOnField(1,0,60150624)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1)
	c:EnableReviveLimit()
	--spsummon
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(aux.synlimit)
	c:RegisterEffect(e11)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetOperation(c60150624.sumsuc)
	c:RegisterEffect(e3)
	--[[tograve
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e4:SetCondition(c60150624.descon)
	e4:SetTarget(c60150624.tgtg)
	e4:SetOperation(c60150624.tgop)
	c:RegisterEffect(e4)]]
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c60150624.condition)
	e1:SetCost(c60150624.thcost)
	e1:SetTarget(c60150624.thtg)
	e1:SetOperation(c60150624.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,60150624)
	e2:SetCondition(c60150624.condition2)
	e2:SetCost(c60150624.cost)
	e2:SetTarget(c60150624.target)
	e2:SetOperation(c60150624.operation)
	c:RegisterEffect(e2)
end
function c60150624.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetSummonType()~=SUMMON_TYPE_SYNCHRO then return end
	if Duel.GetFlagEffect(tp,60150624)==0 then return end
	Duel.ResetFlagEffect(tp,60150624)
end
--[[function c60150624.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c60150624.tgfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c60150624.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150624.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c60150624.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(60150624,0)) then
		local g=Duel.SelectMatchingCard(tp,c60150624.tgfilter,tp,LOCATION_GRAVE,0,1,2,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			local tc=g:GetFirst()
			local c=e:GetHandler()
			while tc do
			if tc:GetAttribute()==ATTRIBUTE_EARTH then
				--immune
				local e5=Effect.CreateEffect(c)
				e5:SetDescription(aux.Stringid(60150624,1))
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(c60150624.efilter1)
				e5:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e5)
			end
			if tc:GetAttribute()==ATTRIBUTE_WATER then
				--immune
				local e5=Effect.CreateEffect(c)
				e5:SetDescription(aux.Stringid(60150624,2))
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(c60150624.efilter2)
				e5:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e5)
			end
			if tc:GetAttribute()==ATTRIBUTE_FIRE then
				--immune
				local e5=Effect.CreateEffect(c)
				e5:SetDescription(aux.Stringid(60150624,3))
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(c60150624.efilter3)
				e5:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e5)			
			end
			if tc:GetAttribute()==ATTRIBUTE_WIND then
				--immune
				local e5=Effect.CreateEffect(c)
				e5:SetDescription(aux.Stringid(60150624,4))
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(c60150624.efilter4)
				e5:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e5)			
			end
			if tc:GetAttribute()==ATTRIBUTE_LIGHT then
				--immune
				local e5=Effect.CreateEffect(c)
				e5:SetDescription(aux.Stringid(60150624,5))
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(c60150624.efilter5)
				e5:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e5)
			end
			if tc:GetAttribute()==ATTRIBUTE_DARK then
				--immune
				local e5=Effect.CreateEffect(c)
				e5:SetDescription(aux.Stringid(60150624,6))
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(c60150624.efilter6)
				e5:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e5)
			end
			if tc:GetAttribute()==ATTRIBUTE_DEVINE then
				--immune
				local e5=Effect.CreateEffect(c)
				e5:SetDescription(aux.Stringid(60150624,7))
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e5:SetRange(LOCATION_MZONE)
				e5:SetCode(EFFECT_IMMUNE_EFFECT)
				e5:SetValue(c60150624.efilter7)
				e5:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e5)
			end
			tc=g:GetNext()
			end
		end
	end
end
function c60150624.efilter1(e,te)
	if te:IsActiveType(TYPE_MONSTER) then
			return te:GetOwner()~=e:GetHandler() and te:GetHandler():IsAttribute(ATTRIBUTE_EARTH)
	end
	return false
end
function c60150624.efilter2(e,te)
	if te:IsActiveType(TYPE_MONSTER) then
			return te:GetOwner()~=e:GetHandler() and te:GetHandler():IsAttribute(ATTRIBUTE_WATER)
	end
	return false
end
function c60150624.efilter3(e,te)
	if te:IsActiveType(TYPE_MONSTER) then
			return te:GetOwner()~=e:GetHandler() and te:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
	end
	return false
end
function c60150624.efilter4(e,te)
	if te:IsActiveType(TYPE_MONSTER) then
			return te:GetOwner()~=e:GetHandler() and te:GetHandler():IsAttribute(ATTRIBUTE_WIND)
	end
	return false
end
function c60150624.efilter5(e,te)
	if te:IsActiveType(TYPE_MONSTER) then
			return te:GetOwner()~=e:GetHandler() and te:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)
	end
	return false
end
function c60150624.efilter6(e,te)
	if te:IsActiveType(TYPE_MONSTER) then
			return te:GetOwner()~=e:GetHandler() and te:GetHandler():IsAttribute(ATTRIBUTE_DARK)
	end
	return false
end
function c60150624.efilter7(e,te)
	if te:IsActiveType(TYPE_MONSTER) then
			return te:GetOwner()~=e:GetHandler() and te:GetHandler():IsAttribute(ATTRIBUTE_DEVINE)
	end
	return false
end]]
function c60150624.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function c60150624.cfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c60150624.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150624.cfilter,tp,LOCATION_DECK,0,1,nil,tp) 
		and Duel.IsExistingTarget(c60150624.tgfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60150624.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c60150624.tgfilter2(c)
	return c:IsAbleToDeck() or c:IsAbleToExtra()
end
function c60150624.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c60150624.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60150624.tgfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c60150624.cfilter2(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER)
		and c:GetPreviousControler()==tp and c:GetControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c60150624.filter(c)
	return c:IsFaceup() and c:GetCode()==60150624
end
function c60150624.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60150624.cfilter2,1,nil,tp) and Duel.GetFlagEffect(tp,60150624)==0 
		and not Duel.IsExistingMatchingCard(c60150624.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150624.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c60150624.spfilter(c,e,tp)
	return c:IsSetCard(0x3b21) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150624.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60150624.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c60150624.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60150624.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(TYPE_TUNER)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(60150624,8))
			e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
			Duel.SpecialSummonComplete()
			Duel.BreakEffect()
			Duel.RegisterFlagEffect(tp,60150624,0,0,1)
		end
	end
end