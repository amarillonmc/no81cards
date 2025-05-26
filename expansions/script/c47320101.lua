--雾锁窗实体“拜访者”
local s,id=GetID()
function s.tofield(c)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsForbidden()
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        local istf=Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
        local zone=c:GetColumnZone(LOCATION_MZONE,tp)
        if istf and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,47320100,0,TYPES_TOKEN_MONSTER,0,1500,3,RACE_ILLUSION,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE)
        and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            local token=Duel.CreateToken(tp,47320100)
	        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
        end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and not c:IsLocation(LOCATION_EXTRA)
end
function s.tohand(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.thcon)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.spcfilter(c,tp,mc)
	if c:IsPreviousControler(1-tp) then return false end
	local zone=mc:GetColumnZone(LOCATION_MZONE,tp)
	local seq=c:GetPreviousSequence()
	return zone and bit.extract(zone,seq)~=0
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS and eg:IsExists(s.spcfilter,1,nil,tp,e:GetHandler())
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_SZONE) and c:IsAbleToHand() then
        Duel.SendtoHand(c,tp,REASON_EFFECT)
    end
end
function s.eff2(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id-1000)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(s.e2con)
	e1:SetTarget(s.e2tg)
	e1:SetOperation(s.e2op)
	c:RegisterEffect(e1)
end
function s.e2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function s.shfilter(c)
	return c:IsSetCard(0x6c12) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.shfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.initial_effect(c)
	s.tofield(c)
    s.tohand(c)
    s.eff2(c)
end
