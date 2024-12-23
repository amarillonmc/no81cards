--孔科耳狄亚
local s,id,o=GetID()
function s.initial_effect(c)
    --CounterSet
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+id)
    e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
    e1:SetCost(s.cost)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
    e2:SetCost(s.cost)
	e2:SetTarget(s.tdtg2)
	e2:SetOperation(s.tdop2)
	c:RegisterEffect(e2)
    if not s.SetCard_Check then
		s.SetCard_Check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
        local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(s.custop)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.tdfi1ter(c)
	return c:IsPreviousLocation(0x41) and c:IsLocation(0x08)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(s.tdfi1ter,nil)
	if #g>0 then
	    for tc in aux.Next(g) do
            tc:RegisterFlagEffect(id,RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
        end
    end
end
function s.target(c)
	return c:GetFlagEffect(id)>0
end
function s.custop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.target,tp,0x08,0x08,nil)
    if #g>0 and ev<=1 then
        Duel.RaiseEvent(g,EVENT_CUSTOM+id,re,0,0,0,0)
    end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.tdfi2ter(c,tp)
	return c:IsControler(1-tp) and s.tdfi1ter(c)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.tdfi2ter,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.tdfi2ter,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function s.tdfi3ter(c,tp)
	return c:IsControler(1-tp) and c:GetFlagEffect(id)>0 and s.tdfi1ter(c)
end
function s.tdfi4ter(c,tp)
	return c:IsControler(1-tp) and c:GetFlagEffect(id+1)>0 and s.tdfi1ter(c)
end
function s.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=eg:Filter(s.tdfi3ter,nil,tp)
        for tc in aux.Next(g) do
            tc:ResetFlagEffect(id)
            if tc:GetFlagEffect(id+1)>0 then tc:ResetFlagEffect(id+1) end
            tc:RegisterFlagEffect(id+1,RESETS_STANDARD-RESET_TURN_SET,0,1)
        end
        return #g>0
    end
    local ng=Duel.GetMatchingGroup(s.tdfi4ter,tp,0,0x08,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,ng,#ng,0,0)
end
function s.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfi4ter,tp,0,0x08,nil,tp)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end