local cm,m = GetID()
cm.tab = {}
cm.tab[0],cm.tab[1] = {},{}
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,m+100)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetHintTiming(TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,0)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
    if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    local t = Duel.GetTurnCount()
	for c in aux.Next(eg) do
	    local py = c:GetSummonPlayer()
	    cm.tab[py][t] = cm.tab[py][t] and cm.tab[py][t] + 1 or 1
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local t,ph = Duel.GetTurnCount(),Duel.GetCurrentPhase()
    tp = tp or e:GetHandlerPlayer()
    cm.tab[1-tp][t] = cm.tab[1-tp][t] or 0
    cm.tab[1-tp][t-1] = cm.tab[1-tp][t-1] or 0
    return cm.tab[1-tp][t]>=3 or (t>1 and cm.tab[1-tp][t-1]>=3 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function cm.f(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_WIND) and (c:IsRace(RACE_AQUA) or c:IsRace(RACE_SEASERPENT) or c:IsRace(RACE_FISH))
end
function cm.ff(g)
    return g:GetClassCount(Card.GetLevel)==1 and g:GetClassCount(Card.GetRace)==g:GetCount()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(cm.ff,1,3) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local ft,g,c = 3,Duel.GetMatchingGroup(cm.f,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp),e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not g:CheckSubGroup(cm.ff,1,3) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then ft = Duel.GetLocationCount(tp,LOCATION_MZONE) end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    ::start::
    local mg=g:SelectSubGroup(tp,cm.ff,true,1,ft)
    if mg then
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	else
	    goto start
	end
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.limit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.limit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.fff,tp,LOCATION_REMOVED,0,nil)
    for _,rac in ipairs({RACE_SEASERPENT,RACE_FISH,RACE_AQUA}) do
        if g:FilterCount(Card.IsRace,nil,rac)<=0 then return false end
    end
	return Duel.GetTurnPlayer()==tp 
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.fff(c)
    return (c:IsRace(RACE_AQUA) or c:IsRace(RACE_SEASERPENT) or c:IsRace(RACE_FISH))
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end