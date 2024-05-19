--血腥蔷薇 窥视欲
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(s.ttcon)
	e1:SetOperation(s.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CUSTOM+id)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(s.dcon)
	e4:SetCost(s.dcost)
	e4:SetTarget(s.dtg)
	e4:SetOperation(s.dop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(s.regcon)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW or Duel.GetCurrentPhase()==0 then return false end
	local v=0
	if eg:IsExists(s.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(s.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,ep,e:GetLabel())
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function s.dcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==1-tp or ev==PLAYER_ALL
end
function s.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.ConfirmCards(tp,sg)
		local tc=sg:GetFirst()
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetLabel(fid)
		e2:SetTarget(s.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e3,tp)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e4,tp)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_SSET)
		Duel.RegisterEffect(e5,tp)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e6:SetCode(EFFECT_CANNOT_ACTIVATE)
		e6:SetTargetRange(0,1)
		e6:SetValue(s.aclimit)
		e6:SetLabel(fid)
		e6:SetLabelObject(tc)
		e6:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e6,tp)
	end
end
function s.splimit(e,c)
	return c:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.aclimit(e,re,tp)
	local c=re:GetHandler()
	local tc=e:GetLabelObject()
	return c==tc and c:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(math.ceil(c:GetBaseAttack()/2))
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(math.ceil(c:GetBaseDefense()/2))
	c:RegisterEffect(e2)
end