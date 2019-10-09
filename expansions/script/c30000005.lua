--终焉邪魂 暗之仆从
function c30000005.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,30000005)
	e1:SetCondition(c30000005.stcon)
	e1:SetCost(c30000005.stcost)
	e1:SetTarget(c30000005.sttg)
	e1:SetOperation(c30000005.stop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c30000005.sptg)
	e2:SetOperation(c30000005.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,30000006)
	e4:SetTarget(c30000005.satg)
	e4:SetOperation(c30000005.saop)
	c:RegisterEffect(e4)
end
function c30000005.satg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:CheckUniqueOnField(tp) end
end
function c30000005.saop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

function c30000005.stcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x920) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c30000005.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,3,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,3,3,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c30000005.sttgfil(c,code)
	return c:IsCode(code) and c:IsSSetable()
end
function c30000005.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=re:GetHandler():GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(c30000005.sttgfil,tp,LOCATION_DECK,0,1,nil,code) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c30000005.stop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end 
	local code=re:GetHandler():GetCode()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c30000005.sttgfil,tp,LOCATION_DECK,0,1,1,nil,code)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		elseif tc:IsType(TYPE_TRAP) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		Duel.ConfirmCards(1-tp,g)
	end
end

function c30000005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,30000009,0,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function c30000005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,30000009,0,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or (Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1) then return end
	for i=1,ft do
		local token=Duel.CreateToken(tp,30000009)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	token:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c30000005.fuslimit)
	token:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	token:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	token:RegisterEffect(e5)
	token:RegisterFlagEffect(30000005,RESET_EVENT+RESETS_STANDARD,0,1)
	 local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetCountLimit(1)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e6:SetLabelObject(token)
		e6:SetCondition(c30000005.descon)
		e6:SetOperation(c30000005.desop)
		Duel.RegisterEffect(e6,tp)
	end
end
function c30000005.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c30000005.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(30000005)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c30000005.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end