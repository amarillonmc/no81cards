--抒情歌鸲-歌鸲联合
local s,id,o=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_LVCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.tg)
    e1:SetOperation(s.op)
    c:RegisterEffect(e1)
end
function s.filter(c,tp)
    local lv=c:GetRank()
    return  c:IsRace(RACE_WINDBEAST) and c:IsType(TYPE_XYZ) and not c:IsPublic() and
    Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,lv)
end
function s.cfilter(c,lv)
    return c:IsFaceup() and c:IsRace(RACE_WINDBEAST) and (c:GetLevel() and not c:IsLevel(lv))
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
    local tc=g:GetFirst()
    Duel.ConfirmCards(1-tp,tc)
    e:SetLabel(tc:GetRank())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(id,0))
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetAbsoluteRange(tp,1,0)
		e3:SetTarget(s.splimit)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_CONTROL)
		tc:RegisterEffect(e3,true)
        tc=g:GetNext()
    end
end
function s.splimit(e,c)
	return not c:IsRace(RACE_WINDBEAST) and c:IsLocation(LOCATION_EXTRA)
end