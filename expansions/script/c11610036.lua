--光之修长角幻兔

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
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.atkdefcon)
	e1:SetTarget(s.atkdeftg)
	e1:SetOperation(s.atkdefop)
	c:RegisterEffect(e1)	
	
end

function s.efilter(e,te)
    local tc=te:GetHandler()
    if (te:GetOwner()~=e:GetOwner() and tc:IsCode(25795273)) then return true end
    return tc:IsType(TYPE_MONSTER) and tc:GetAttack()==0
end

function s.atkdeffilter(c)
    return c:IsFaceup() and c:GetAttack()==0
end
function s.atkdefcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.atkdeffilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
    and ep~=tp
end
function s.atkdeftg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,0,0,LOCATION_MZONE)
end
function s.atkdefop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeChainOperation(ev,s.repop)
end
function s.downvalue(e,c)
    local atk=0
    if c:GetLink()>0
        then atk=c:GetLink()
    elseif c:GetRank()>0
        then ark=c:GetRank()
    elseif c:GetLevel()>0
        then atk=c:GetLevel()
    end
    return atk*-300
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(s.downvalue)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
