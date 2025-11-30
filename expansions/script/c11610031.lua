--光角月兔

--光角幻兔卡号
local key=25795273
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,25795273)
    aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsCode,25795273),nil,nil,aux.NonTuner(nil),1,99)
    --change name
	aux.EnableChangeCode(c,25795273)
    --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WYRM))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e2)
	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(s.rmcon)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end

function s.efilter(e,te)
    local tc=te:GetHandler()
    if tc:IsCode(25795273) and te:GetOwner()~=e:GetOwner() then return true end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetMinGroup(Card.GetAttack)
	if tg:GetCount()>0 and tg:IsContains(tc) then
	    return true
	else
	    return false
	end
end

function s.atkupfilter(c)
    return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function s.atkuptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.atkupfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,1,0,0)
end
function s.atkupop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not (c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(s.atkupfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)) then return end
    local atk=0
    local g=Duel.GetMatchingGroup(s.atkupfilter,tp,LOCATION_NZONE,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        atk=tc:GetAttack()-tc:GetBaseAttack()
        if atk<0 then
            atk=atk*-1
        end
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
        tc=g:GetNext()
    end
end

function s.rmfilter(c,atk)
    return c:IsFaceup() and c:GetBaseAttack()<=atk and c:GetBaseAttack()~=0
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and rc:GetBaseAttack()~=rc:GetAttack()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not (tc:IsRelateToEffect(e)) then return end
    Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end