--颶風海劫“庇佑”金鹿號
local s,id,o=GetID()
function s.initial_effect(c)
    --Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
    --Cannot Be Target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0x0c,0)
	e2:SetTarget(s.etlimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
    --Destroy(0x04)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
--Negate
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
        and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(s.thfi1ter,tp,0x0c,0,e:GetHandler())>0 end
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
end
function s.thfi1ter(c)
   return c:IsSetCard(0x540b) and c:IsFaceup()
end
function s.Check(c,tp)
    return c:IsLocation(0x02) and c:IsSetCard(0x540b)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.thfi1ter,tp,0x0c,0,aux.ExceptThisCard(e))
    if #g>0 then
        Duel.Hint(3,tp,505)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        local tc=sg:GetFirst()
        if Duel.SendtoHand(tc,nil,0x40)>0 and s.Check(tc,tp) then
            Duel.NegateActivation(ev)
        end
	end
end
--Cannot Be Target
function s.etlimit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
--Destroy
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousPosition(POS_FACEUP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0x04,0x04,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0x04,0x04,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end