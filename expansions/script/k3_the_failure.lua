K3 = {}
function K3.IsHasLevel(c)
    return c:GetLevel()>0
end
function K3.SelectCard(sel_player,f,player,s,o,ex,...)
    return Duel.SelectMatchingCard(sel_player,f,player,s,o,1,1,ex,...):GetFirst()
end
function K3.SelectTarget(sel_player,f,player,s,o,ex,...)
    return Duel.SelectTarget(sel_player,f,player,s,o,1,1,ex,...):GetFirst()
end
function K3.SelfLimit(f,c,tp)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(f)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function K3.RValue(value)
    return function ()
        return value
    end
end
function K3.IsPhase(phase)
    local ph=Duel.GetCurrentPhase()
    if phase=="draw" then
        return ph==PHASE_DRAW
    elseif phase=="standby" then
        return ph==PHASE_STANDBY
    elseif phase=="main" then
        return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
    elseif phase=="main1" then
        return ph==PHASE_MAIN1
    elseif phase=="battle" then
        return ph>PHASE_MAIN1 and ph<PHASE_MAIN2
    elseif phase=="main2" then
        return ph==PHASE_MAIN2
    elseif phase=="end" then
        return ph==PHASE_END
    else
        error("Unknown phase.")
    end
end
function K3.BreakEffect()
    Duel.BreakEffect()
    return true
end
function K3.SpellActivate(c)
    local e=Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_ACTIVATE)
    e:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e)
end
