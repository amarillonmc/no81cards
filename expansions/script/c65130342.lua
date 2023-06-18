--天井伊吕波
function c65130342.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65130342,2))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,65130342)
	e1:SetCost(c65130342.spcost)
	e1:SetCondition(c65130342.spcon)
	e1:SetTarget(c65130342.sptg)
	e1:SetOperation(c65130342.spop)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c65130342.sccon)
	e2:SetValue(c65130342.scvl)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_RSCALE)
	e3:SetValue(c65130342.scvr)
	c:RegisterEffect(e3)
end
function c65130342.spcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function c65130342.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtra() end
	Duel.SendtoExtraP(c,1-tp,REASON_COST)
end
function c65130342.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(1-tp,1-tp,nil,TYPE_PENDULUM)>0 or Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
function c65130342.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c65130342.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCountFromEx(1-tp,1-tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
	local b2=Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:IsAbleToGrave()
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(1-tp,aux.Stringid(65130342,3))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(1-tp,aux.Stringid(65130342,4))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(1-tp,aux.Stringid(65130342,3),aux.Stringid(65130342,4))
	end
	if not b1 and not b2 then return end
	if s==0 then
		if c then
			Duel.SpecialSummonStep(c,0,1-tp,1-tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_HAND)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			Duel.SpecialSummonComplete()			
		end
	end
	if s==1 then
		if c and Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
			local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
			local val=aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,tc:GetSequence())
			if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e1:SetReset(RESET_PHASE+PHASE_STANDBY)
				e1:SetLabelObject(tc)
				e1:SetCountLimit(1)
				e1:SetOperation(c65130342.retop)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_DISABLE_FIELD)
				e2:SetLabelObject(tc)
				e2:SetCondition(c65130342.discon)
				e2:SetValue(val)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function c65130342.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c65130342.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then
		return true
	else
		e:Reset()
		return false
	end
end
function c65130342.sccon(e)
	return Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function c65130342.scvl(e)
	local tc=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler()):GetFirst()
	if tc then return -tc:GetLeftScale() end
	return 0
end
function c65130342.scvr(e)
	local tc=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler()):GetFirst()   
	if tc then return -tc:GetRightScale() end
	return 0
end