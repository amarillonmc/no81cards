--十六夜咲夜『世界』
local s,id,o=GetID()
function s.initial_effect(c)
    --Act_limit
	local Act_limit=Effect.CreateEffect(c)
	Act_limit:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	Act_limit:SetCode(EVENT_CHAINING)
    Act_limit:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE)
    Act_limit:SetRange(0xff)
	Act_limit:SetOperation(s.chainop)
	c:RegisterEffect(Act_limit)
    --CannotSpSum
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
    --change  
	local e1=Effect.CreateEffect(c) 
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	    return Duel.GetCurrentPhase()==PHASE_MAIN1
            and Duel.GetTurnPlayer()==e:GetHandler():GetSummonPlayer() end)
	e1:SetOperation(s.pscg) 
	c:RegisterEffect(e1)
    --Direct Attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
    e3:SetCondition(s.dacon)
	c:RegisterEffect(e3)
    --disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(s.atisop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(s.atistg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)
    --『The World』
    local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,1))
    e8:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
    e8:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	    return Duel.GetTurnPlayer()==e:GetHandler():GetSummonPlayer() end)
	e8:SetOperation(s.twop)
	c:RegisterEffect(e8)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler() then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.pscg(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
    if ph==PHASE_MAIN1 then
	    Duel.SkipPhase(Duel.GetTurnPlayer(),ph,RESET_PHASE+ph,1)
        local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	    e1:SetTargetRange(1,1)
	    e1:SetValue(aux.TRUE)
	    e1:SetReset(RESET_PHASE+PHASE_MAIN1)
	    Duel.RegisterEffect(e1,tp)
    end
end
function s.filter(c)
	return c:IsFacedown() or not c:IsDisabled()
end
function s.dacon(e)
	return not Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),0,0x04,1,nil)
end
function s.atisop(e,tp,eg,ep,ev,re,r,rp)
    local ater=e:GetHandler():GetBattleTarget()
    if ater~=nil then
    	ater:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
    end
end
function s.atistg(e,c)
	return c:GetFlagEffect(id)~=0
end
function s.twop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetTargetRange(0x04,0)
		e2:SetTarget(s.ftarget)
		e2:SetLabel(c:GetFieldID())
		e2:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e2,tp)
	    local e3=Effect.CreateEffect(c)
	    e3:SetType(EFFECT_TYPE_FIELD)
	    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	    e3:SetTargetRange(0,0x04)
	    e3:SetValue(1)
        e3:SetReset(RESET_PHASE+PHASE_BATTLE)
        Duel.RegisterEffect(e3,tp)
        local e4=Effect.CreateEffect(c)
	    e4:SetType(EFFECT_TYPE_FIELD)
	    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	    e4:SetTargetRange(1,1)
	    e4:SetValue(aux.TRUE)
	    e4:SetReset(RESET_PHASE+PHASE_BATTLE)
	    Duel.RegisterEffect(e4,tp)
        --Damage Reduce
	    local e5=Effect.CreateEffect(c)
	    e5:SetType(EFFECT_TYPE_FIELD)
	    e5:SetCode(EFFECT_CHANGE_DAMAGE)
	    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e5:SetTargetRange(0,1)
	    e5:SetValue(s.damval)
        e5:SetReset(RESET_PHASE+PHASE_BATTLE)
	    Duel.RegisterEffect(e5,tp)
        local e6=Effect.CreateEffect(c)
	    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	    e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	    e6:SetCountLimit(1)
        e6:SetLabelObject(c)
	    e6:SetOperation(s.operation)
	    e6:SetReset(RESET_PHASE+PHASE_BATTLE)
	    Duel.RegisterEffect(e6,tp)
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,nil,0,1)
	end
end
function s.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
        local pl=e:GetHandler():GetControler()
        local df=Duel.GetFlagEffectLabel(1-pl,id)
        if df==nil then 
            Duel.RegisterFlagEffect(1-pl,id,RESET_PHASE+PHASE_BATTLE,0,1,val)
	    else
	        Duel.SetFlagEffectLabel(1-pl,id,df+val)
        end
		return 0
	end
	return val
end
function s.damfilter(c,e)
	return c:IsFaceup() and e:GetHandler():GetBattledGroup():IsContains(c)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
    local c=e:GetLabelObject()
    if c:GetFlagEffect(id) then
        local g=Duel.GetMatchingGroup(s.damfilter,tp,0,0x04,nil,e)
        Duel.Destroy(g,0x40)
        local df=Duel.GetFlagEffectLabel(1-tp,id)
        if df and df>0 then
            Duel.Damage(1-tp,df,0x40)
            Duel.SetFlagEffectLabel(1-tp,id,0)
        end
    end
end