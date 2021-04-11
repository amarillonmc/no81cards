--天穹司书 裁秤之忒弥希爱尔
function c72410260.initial_effect(c)
	aux.AddCodeList(c,56433456)
	--to spell
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72410260,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,72410260)
	e1:SetTarget(c72410260.igtg)
	e1:SetOperation(c72410260.igop)
	c:RegisterEffect(e1)
	--ss success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72410260,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,72410261)
	e2:SetCondition(c72410260.retcon)
	e2:SetTarget(c72410260.rettg)
	e2:SetOperation(c72410260.retop)
	c:RegisterEffect(e2)
	--as spell
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c72410260.spellcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY))
	e3:SetValue(c72410260.atkval)
	c:RegisterEffect(e3)
end
--
function c72410260.igtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND))
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c72410260.igop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND)) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(72410260,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
end
--
function c72410260.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsType(TYPE_SPELL) and rc:IsType(TYPE_CONTINUOUS)
end
function c72410260.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local thchk=Duel.IsEnvironment(56433456)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,nil,g,1,0,0)
end
function c72410260.retop(e,tp,eg,ep,ev,re,r,rp)
	local thchk=Duel.IsEnvironment(56433456)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		if thchk and g:GetFirst():IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(72410260,2)) then
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		else
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
--
function c72410260.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa729)
end
function c72410260.spellcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SPELL) and e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function c72410260.atkval(e,c)
	local g=Duel.GetMatchingGroup(c72410260.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)*500
end
