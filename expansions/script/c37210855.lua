--空白之席 漆黑的究极骑士
local s,id,o=GetID()
function s.initial_effect(c)
    --atkng
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.atcon)
	e1:SetTarget(s.attg)
	e1:SetOperation(s.atop)
	c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1,id+o+id)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
         Duel.BreakEffect() 
        c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.negcon)
	e1:SetOperation(s.negop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetOwner()
    local cnt=c:GetFlagEffectLabel(id) or 0
	return Duel.GetAttacker():IsControler(1-tp) and cnt<12
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
     if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
    Duel.NegateAttack()
    local c=e:GetOwner()
        local cnt=c:GetFlagEffectLabel(id) or 0
        c:SetFlagEffectLabel(id,cnt+1)
end
end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local atk=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)*1000
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end