--猎兽之王：振翅
local s,id,o=GetID()
function s.initial_effect(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.spcon)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.stcost)
	e1:SetTarget(s.sttg)
	e1:SetOperation(s.stop)
	c:RegisterEffect(e1)
end
s.hackclad=1
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()==0 then return end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.handcon(e)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.lmfilter(c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>2
end
function s.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:GetHandler():CancelToGrave()
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup() and (c:IsLevelAbove(10) or c:IsRankAbove(10))
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.IsExistingMatchingCard(s.lmfilter,tp,LOCATION_MZONE,0,1,nil) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsControler(tp) and not tc:IsImmuneToEffect(e)) then return end
	local zone=1<<4-tc:GetSequence()
	local oc=Duel.GetMatchingGroup(s.seqfilter,tp,0,LOCATION_MZONE,nil,tc:GetSequence()):GetFirst()
	if oc then
		Duel.Destroy(oc,REASON_RULE)
	end
	if Duel.GetControl(tc,1-tp,0,0,zone) then
		local oc=Duel.GetMatchingGroup(s.seqfilter,tp,0,LOCATION_SZONE,nil,tc:GetSequence()):GetFirst()
		if oc then
			Duel.Destroy(oc,REASON_RULE)
		end
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) and Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,zone) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			local oc=Duel.GetMatchingGroup(s.seqfilter,tp,0,LOCATION_MZONE,nil,tc:GetSequence()):GetFirst()
			if oc then
				Duel.Destroy(oc,REASON_RULE)
			end
			if Duel.SelectYesNo(tp,aux.Stringid(id,2)) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone) then
			end
		end
	end
end
function s.seqfilter(c,seq)
	return 4-c:GetSequence()==seq
end