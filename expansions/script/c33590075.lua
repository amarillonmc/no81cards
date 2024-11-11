local m=33590075
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	--e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCost(cm.tgcost)
	--e1:SetTarget(cm.tgtg)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(cm.pbcon2)
	e1:SetOperation(cm.pbop)
	c:RegisterEffect(e1)
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	--e2:SetTargetRange(1,0)
	e2:SetCondition(cm.pbcon)
	--e2:SetValue(0x7f)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.pbcon3)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
	--maintain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.pbcon)
	e5:SetOperation(cm.mtop)
	c:RegisterEffect(e5)
end
function cm.tgfilter(c)
	return c:GetSequence()<5
end
function cm.pbcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return not c:IsPublic()
end
function cm.pbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(9822220,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local sg=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_MZONE,0,nil)
	if sg:GetCount()>0 then
	    Duel.SendtoGrave(sg,REASON_RULE)
	end
end
function cm.pbcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPublic()
end
function cm.disop(e,tp)
	return 0x1f
end
function cm.pbcon3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPublic() and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local atk=sg:GetFirst():GetBaseAttack()
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsAbleToRemove(tp,POS_FACEDOWN) then
        Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
        return
    end
	if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
	    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
		local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		Duel.SetLP(tp,lp2)
		Duel.SetLP(1-tp,lp1)
	end
end