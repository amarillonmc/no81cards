local m=33590078
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	--e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCost(cm.cost)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	c:RegisterEffect(e2)
end
function cm.tfilter(c,lv)
	return c:IsLevelAbove(5) and c:IsLevelAbove(lv) and c:IsAbleToHand()
end
function cm.filter(c,e,tp)
    local lv=c:GetLevel()
	return c:IsFaceup() and lv>0 and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_DECK,0,1,nil,lv)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local lv=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local tc=g:GetFirst()
	    local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_PUBLIC)
	   	if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
			tc:RegisterFlagEffect(9822220,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,2,fid,66)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
			tc:RegisterFlagEffect(9822220,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
		end
	    tc:RegisterEffect(e1)
	    local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
	    end
		e2:SetCondition(cm.discon)
		tc:RegisterEffect(e2)
		--cannot attack
	    local e3=Effect.CreateEffect(e:GetHandler())
	    e3:SetType(EFFECT_TYPE_FIELD)
	    e3:SetCode(EFFECT_CANNOT_ATTACK)
	    e3:SetRange(LOCATION_HAND)
	    e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetCondition(cm.atkcon)
	    e3:SetTarget(cm.atktarget)
	    tc:RegisterEffect(e3)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)>Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil) and c:IsPublic()
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPublic() and c:IsLocation(LOCATION_HAND)
end
function cm.atktarget(e,c)
    local tc=e:GetHandler()
	return c:GetAttack()<tc:GetAttack()
end
function cm.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>1 and (c:IsControler(tp) or c:IsFaceup())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,cm.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end