--旅界者 奎萨兹
local s,id=GetID()
function s.initial_effect(c)
	s.sprule(c)
    s.remove(c)
    s.todeck(c)
    s.activate(c)
end
function s.sprule(c)
    local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
end
function s.splimit(e,se)
    if not se then return false end
    local sc=se:GetHandler()
	return sc:IsSetCard(0xac12) or sc:IsType(TYPE_MONSTER) and sc:IsRace(RACE_PSYCHO)
end

function s.remove(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.rmtg)
    e1:SetOperation(s.rmop)
    c:RegisterEffect(e1)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3
		and Duel.GetDecktopGroup(tp,3):FilterCount(Card.IsAbleToRemove,nil)==3) or
        (Duel.GetFieldGroupCount(1-tp,0,LOCATION_DECK)>=3
		and Duel.GetDecktopGroup(1-tp,3):FilterCount(Card.IsAbleToRemove,nil)==3) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,4,1-tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local flag=0
    if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3
    and Duel.GetDecktopGroup(tp,3):FilterCount(Card.IsAbleToRemove,nil)==3 then
       flag=flag+1 
    end
    if Duel.GetFieldGroupCount(1-tp,0,LOCATION_DECK)>=3
    and Duel.GetDecktopGroup(1-tp,3):FilterCount(Card.IsAbleToRemove,nil)==3 then
        flag=flag+2
    end
    if flag==3 then
        if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
            flag=1
        else
            flag=2
        end
    end
    if flag==1 then
        local g=Duel.GetDecktopGroup(1-tp,3)
        if #g>0 then
            Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        end
    else
        local g=Duel.GetDecktopGroup(tp,3)
        if #g>0 then
            Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        end
    end

end

function s.todeck(c)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(TIMING_MAIN_END,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.tdcon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.tdtg)
    e2:SetOperation(s.tdop)
    c:RegisterEffect(e2)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,1,nil)
end
function s.tdfilter(c)
    return c:IsAbleToDeck() and c:IsFaceup()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_SZONE,0,nil)
    local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_FZONE,nil)
    if #tg>0 then
        g:Merge(tg)
    end
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_SZONE,0,nil)
    local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_FZONE,nil)
    if #tg>0 then
        g:Merge(tg)
    end
    if #g>0 then
        Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end

function s.activate(c)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCountLimit(1,id-1000)
    e3:SetCost(s.accost)
    e3:SetTarget(s.actg)
    e3:SetOperation(s.acop)
    c:RegisterEffect(e3)
end
function s.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function s.acfilter(c,tp)
    return c:IsType(TYPE_FIELD) and c:IsSetCard(0xac12) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.acfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,s.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    Duel.ResetFlagEffect(tp,15248873)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
        if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		local b2=te:IsActivatable(tp,true,true)
		Duel.ResetFlagEffect(tp,15248873)
        if not b2 then return end
        local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
        if fc then
            Duel.SendtoGrave(fc,REASON_RULE)
            Duel.BreakEffect()
        end
        Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
        te:UseCountLimit(tp,1,true)
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end