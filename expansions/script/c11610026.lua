--光角有翼幻兔

--光角幻兔卡号
local key=25795273
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,25795273)
    aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsCode,25795273),nil,nil,aux.NonTuner(nil),1,99)
    --change name
	aux.EnableChangeCode(c,25795273)
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetValue(s.efilter)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.atkuptg)
	e1:SetOperation(s.atkupop)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

function s.econfilter(c,tc)
    return c:IsFaceup() and c:GetAttack()<tc:GetAttack()
end
function s.efilter(e,te)
    local tc=te:GetHandler()
    if (te:GetOwner()~=e:GetOwner() and tc:IsCode(25795273)) then return true end
    local c=e:GetHandler()
    return tc:IsLocation(LOCATION_MZONE) and not Duel.IsExistingMatchingCard(s.econfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tc) 
end

function s.atkupfilter(c)
    return c:IsFaceup() and c:GetAttack()<c:GetBaseAttack()
end
function s.atkuptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.atkupfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,0)
end
function s.atkupop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not (c:IsRelateToEffect(e)) then return end
    local atk=0
    local g=Duel.GetMatchingGroup(s.atkupfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
    local tc=g:GetFirst()
    while tc do
        atk=tc:GetBaseAttack()-tc:GetAttack()
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(atk/2)
		c:RegisterEffect(e1)
        tc=g:GetNext()
    end
end

function s.desatkfilter(c,atk)
    return c:GetAttack()<atk
end
function s.desfilter(c,atk)
    return c:IsFaceup() 
    and c:GetBaseAttack()~=0 
    and c:GetBaseAttack()<=atk 
    and not Duel.IsExistingMatchingCard(s.desatkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) 
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack())  end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetAttack())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_MZONE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not (tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:GetAttack()>=tc:GetBaseAttack()) then return end
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-1*tc:GetBaseAttack())
	c:RegisterEffect(e1)
    Duel.Destroy(tc,REASON_EFFECT)
end