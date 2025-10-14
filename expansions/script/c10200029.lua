-- 穴墓的指名者
function c10200029.initial_effect(c)
    -- 除外并无效
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c10200029.target)
    e1:SetOperation(c10200029.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetCondition(c10200029.chcondition)
    e2:SetTarget(c10200029.chtarget)
    e2:SetOperation(c10200029.activate)
    c:RegisterEffect(e2)
    -- 检测对方陷阱卡发动状态并设置flag
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(0)
    e3:SetCondition(c10200029.trapcheckcon)
    e3:SetOperation(c10200029.trapcheckop)
    Duel.RegisterEffect(e3,0)
end
-- 1
function c10200029.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c10200029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local hasFlag = Duel.GetFlagEffect(1-tp,10200029)>0
    if chkc then
        return chkc:IsControler(1-tp) and
               (chkc:IsLocation(LOCATION_GRAVE) or (hasFlag and chkc:IsLocation(LOCATION_ONFIELD))) and
               c10200029.filter(chkc)
    end
    if chk==0 then
        if hasFlag then
            return Duel.IsExistingTarget(c10200029.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
        else
            return Duel.IsExistingTarget(c10200029.filter,tp,0,LOCATION_GRAVE,1,nil)
        end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g
    if hasFlag then
        g=Duel.SelectTarget(tp,c10200029.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
    else
        g=Duel.SelectTarget(tp,c10200029.filter,tp,0,LOCATION_GRAVE,1,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c10200029.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		e1:SetTarget(c10200029.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c10200029.discon)
		e2:SetOperation(c10200029.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c10200029.distg(e,c)
    local tc=e:GetLabelObject()
    return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c10200029.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c10200029.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
-- 2
function c10200029.chcondition(e,tp,eg,ep,ev,re,r,rp)
    return re and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10200029.chfilter(c,code)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() and c:IsOriginalCodeRule(code)
end
function c10200029.chtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local rc=re:GetHandler()
    local code=rc:GetOriginalCodeRule()
    if chkc then return chkc:IsControler(1-tp) and (chkc:IsLocation(LOCATION_GRAVE) or chkc:IsLocation(LOCATION_ONFIELD)) and c10200029.chfilter(chkc,code) end
    if chk==0 then
        return Duel.IsExistingTarget(c10200029.chfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,code)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c10200029.chfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,code)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
    Duel.RegisterFlagEffect(1-tp,10200029,RESET_PHASE+PHASE_END,0,1)
end
-- 3
function c10200029.trapcheckcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    return rc:IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsPreviousLocation(LOCATION_HAND) and rc:GetControler()==1-tp
end
function c10200029.trapcheckop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(1-tp,10200029,RESET_PHASE+PHASE_END,0,1)
end
