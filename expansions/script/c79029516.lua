--CiNO.53 伪骸虚神·心帝星
function c79029516.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,5,c79029516.ovfilter,aux.Stringid(79029516,0))
	c:EnableReviveLimit()
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029516.descon)
	e1:SetTarget(c79029516.destg)
	e1:SetOperation(c79029516.desop)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c79029516.catktg)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c79029516.atkval)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029516,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,c79029516)
	e4:SetCondition(c79029516.spcon)
	e4:SetTarget(c79029516.sptg)
	e4:SetOperation(c79029516.spop)
	c:RegisterEffect(e4)
end
aux.xyz_number[79029516]=53
function c79029516.ovfilter(c)
	return c:IsFaceup() and c:IsCode(23998625)
end
function c79029516.descon(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg:IsContains(e:GetHandler())
end
function c79029516.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c79029516.desop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
	Duel.Remove(g,POS_FACEUP+POS_FACEDOWN,REASON_EFFECT)
end
end
function c79029516.catktg(e,c)
	return c:IsFaceup() and c:GetCode()~=79029516
end
function c79029516.atkfilter(c)
	return c:IsFaceup()
end
function c79029516.atkval(e,c)
	local g=Duel.GetMatchingGroup(c79029516.atkfilter,tp,0,LOCATION_MZONE,nil)
	local atk=g:GetSum(Card.GetBaseAttack)
	return atk
end
function c79029516.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
end
function c79029516.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local rec=e:GetHandler():GetBaseAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c79029516.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,3)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	end
	e1:SetCountLimit(1)
	e1:SetCondition(c79029516.spcon2)
	e1:SetOperation(c79029516.spop2)
	c:RegisterEffect(e1)
	c:SetTurnCounter(0)
end
function c79029516.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c79029516.spop2(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==1 then
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		local at=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)
		local ba=e:GetHandler():GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(ba+at*1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
