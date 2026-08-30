local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc and tc:IsFaceup() do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
		tc=eg:GetNext()
	end
	Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c) and c:GetFlagEffect(id)>0 and c:GetFlagEffect(id+500)==0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	for i=1,ev do if Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)~=e then return false end end
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetLabelObject(e)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	return re~=e:GetLabelObject()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(id) or 0
	if ct==0 then c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,1) else c:SetFlagEffectLabel(id,ct+1) end
	if Duel.CheckLPCost(tp,100*(ct+1)) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then Duel.PayLPCost(tp,100*(ct+1)) else c:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD,0,1) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
