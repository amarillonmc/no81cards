--源于黑影 入侵
local s,id,o=GetID()
function s.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCondition(s.condition)
  e1:SetTarget(s.target)
  e1:SetOperation(s.activate)
  c:RegisterEffect(e1)
	local e2=e1:Clone()
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCondition(aux.TRUE)
  e2:SetCost(s.gravecost)
  c:RegisterEffect(e2)
  local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(s.actarget)
	e4:SetOperation(s.acop)
	c:RegisterEffect(e4)
 if not RZFZ_REMOVE0_THISTURN then
		RZFZ_REMOVE0_THISTURN=true
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_CUSTOM+65820000)
		ge6:SetCondition(s.spcon)
		ge6:SetOperation(s.checkop6)
		Duel.RegisterEffect(ge6,0)
	end
end

function s.cfilter1(c)
	return c:IsSetCard(0x3a32)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil)
end
function s.checkop6(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,65820105,RESET_PHASE+PHASE_END,0,1)
end

function s.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    if rp~=1-tp then return false end
    local re=Duel.GetChainInfo(ev-1, CHAININFO_TRIGGERING_EFFECT)
    if not re then return false end
    local rc=re:GetHandler()
    return rc:IsSetCard(0x3a32) and re:GetHandlerPlayer()==tp
end

function s.gravecost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local ct=Duel.GetFlagEffect(tp,65820105)
  if chk==0 then return ct>0 and c:IsLocation(LOCATION_GRAVE) end
  local count=math.max(Duel.GetFlagEffect(tp,65820105)-1,0)
	Duel.ResetFlagEffect(tp,65820105)
	for i=1,count do
		Duel.RegisterFlagEffect(tp,65820105,0,0,1)
	end
  local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local c=e:GetHandler()
  e:SetLabel(0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetOperation(s.replaceop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		e2:SetOperation(s.replaceop2)
		e2:SetReset(RESET_CHAIN)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
  end
end
function s.replaceop(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsSetCard(0x3a32) then return end
    local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev, s.drawop)
end
function s.replaceop2(e,tp,eg,ep,ev,re,r,rp)
    e:GetLabelObject():Reset()
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    Duel.Draw(1-tp, 1, REASON_EFFECT)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local chain_count=Duel.GetCurrentChain()
    local lp_cost=chain_count*1000
    if lp_cost>0 then
        Duel.SetLP(tp, Duel.GetLP(tp)-lp_cost)
        if Duel.GetLP(tp)<=0 then
            Duel.SetLP(tp, 4000)
            Duel.RaiseEvent(c, EVENT_CUSTOM+65820000, e, REASON_EFFECT, tp, tp, 4000)
        end
    end
end