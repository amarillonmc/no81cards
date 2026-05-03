--死冥霸权
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--盖放	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)    
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x364b)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and Duel.IsChainNegatable(i) then
			return true
		end
	end
	return false
end    
function s.tgfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x364b)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCurrentChain()
    local tg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return tg:GetCount()>=ct+1 end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)			
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,ct,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
    local tg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
    local sg=tg:Select(tp,ct,ct,nil)
    if sg:GetCount()~=ct then return end
    Duel.HintSelection(sg)
    if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)~=0 then
		for i=1,ev do
			local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if tgp~=tp then
        		Duel.NegateActivation(i)			
			end
		end        
	end
end	
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
    if re and re:GetHandler():IsSetCard(0x364b) then
    	e:SetCategory(CATEGORY_RECOVER+CATEGORY_LEAVE_GRAVE)
    end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 and re and re:GetHandler():IsSetCard(0x364b)
    	and Duel.GetFlagEffect(tp,id)==0 then
        Duel.BreakEffect()
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetCondition(s.rccon)
		e1:SetOperation(s.rcop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
        local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetCondition(s.rccon1)
		e2:SetOperation(s.rcop1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetCondition(s.rccon2)
		e3:SetOperation(s.rcop2)
		e3:SetLabelObject(e2)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
        Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    end
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x364b) and c:IsRace(RACE_ZOMBIE)
end
function s.rcfilter(c,tp)
	return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER) and c:GetAttack()~=0
end
function s.rcval(c)
	if c:GetLocation()~=LOCATION_GRAVE then return end
	return math.max(0,c:GetAttack())
end
function s.rccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.rcfilter,1,nil,tp) and not Duel.IsChainSolving()
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(s.rcfilter,nil,tp)
	local atk=tg:GetSum(s.rcval)
    Duel.Hint(HINT_CARD,0,id)
	Duel.Recover(tp,atk,REASON_EFFECT)     
end
function s.rccon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.rcfilter,1,nil,tp) and Duel.IsChainSolving()
end
function s.rcop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(s.rcfilter,nil,tp)
	local g=e:GetLabelObject()
	if g==nil or g:GetCount()==0 then
		tg:KeepAlive()
		e:SetLabelObject(tg)
	else
		g:Merge(tg)
	end
	Duel.RegisterFlagEffect(tp,id+o,RESET_CHAIN,0,1)
end
function s.rccon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+o)>0
end
function s.rcop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,id+o)
	local g=e:GetLabelObject():GetLabelObject()
	tg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local atk=tg:GetSum(s.rcval)
	local og=Group.CreateGroup()
	og:KeepAlive()
	e:GetLabelObject():SetLabelObject(og)
	tg:DeleteGroup()
    Duel.Hint(HINT_CARD,0,id)
	Duel.Recover(tp,atk,REASON_EFFECT)
end