--智商跃升！
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x4)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1x=Effect.CreateEffect(c)
	e1x:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1x:SetCode(EVENT_CHAINING)
	e1x:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1x:SetRange(LOCATION_SZONE)
	e1x:SetCondition(s.ctcon)
	e1x:SetOperation(aux.chainreg)
	c:RegisterEffect(e1x)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.ctcon)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
		return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and Duel.GetTurnPlayer()~=tp and s.cardadvantage(tp) 
	end)
	e4:SetOperation(s.ctop2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.tdcon)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.spcon)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,2))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(s.descon)
	e8:SetOperation(s.desop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,3))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCondition(s.drcon)
	e9:SetOperation(s.drop)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,4))
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCondition(s.descon2)
	e10:SetOperation(s.desop2)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,5))
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCondition(s.skcon)
	e11:SetOperation(s.skop)
	c:RegisterEffect(e11)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1122)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.damcon)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	--damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD_P)
	e7:SetOperation(s.dap)
	c:RegisterEffect(e7)
	e3:SetLabelObject(e7)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and s.cardadvantage(tp)
end
function s.cardadvantage(tp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local ct2=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)
	return ct2>ct1
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)>0 and re:GetHandlerPlayer()~=tp then
		e:GetHandler():AddCounter(0x4,1)
	end
end
function s.ctop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x4,1)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetTurnPlayer()==tp 
	and Duel.GetCurrentChain()<=0 and Duel.IsMainPhase() and e:GetHandler():GetCounter(0x4)>=2 and Duel.GetFlagEffect(tp,id)==0
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():RemoveCounter(tp,0x4,2,REASON_COST)~=0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c,e,tp) return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetTurnPlayer()==tp 
	and Duel.GetCurrentChain()<=0 and Duel.IsMainPhase() and e:GetHandler():GetCounter(0x3)>=3 and Duel.GetFlagEffect(tp,id+10000)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():RemoveCounter(tp,0x4,3,REASON_COST)~=0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(function(c,e,tp) return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_GRAVE,0,1,nil,e,tp),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,id+10000,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetTurnPlayer()==tp 
	and Duel.GetCurrentChain()<=0 and Duel.IsMainPhase() and e:GetHandler():GetCounter(0x4)>=5 and Duel.GetFlagEffect(tp,id+20000)==0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():RemoveCounter(tp,0x4,5,REASON_COST)~=0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,id+20000,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerCanDraw(tp,1) and Duel.GetTurnPlayer()==tp 
	and Duel.GetCurrentChain()<=0 and Duel.IsMainPhase() and e:GetHandler():GetCounter(0x4)>=7 and Duel.GetFlagEffect(tp,id+30000)==0
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():RemoveCounter(tp,0x4,7,REASON_COST)~=0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.desfilter(c)
	if c:IsLocation(LOCATION_FZONE) then return false end
	return true
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetTurnPlayer()==tp 
	and Duel.GetCurrentChain()<=0 and Duel.IsMainPhase() and e:GetHandler():GetCounter(0x4)>=11 and Duel.GetFlagEffect(tp,id+40000)==0
end
function s.seqcheck(c,tp,i)
	if c:IsLocation(LOCATION_FZONE) then return false end
	if c:IsControler(tp) then
		if c:GetSequence()==5 then
			return i==1
		elseif c:GetSequence()==6 then
			return i==3
		else
			return c:GetSequence()==i
		end
	else
		if c:GetSequence()==5 then
			return i==3
		elseif c:GetSequence()==6 then
			return i==1
		else
			return c:GetSequence()==4-i
		end
	end
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():RemoveCounter(tp,0x4,11,REASON_COST)~=0 then
		Duel.Hint(HINT_CARD,0,id)
		local c=e:GetHandler()
		local tab={}
		for i=0,4 do
			if Duel.IsExistingMatchingCard(s.seqcheck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,i) then
				table.insert(tab,i+1)
			end
		end
		local num=Duel.AnnounceNumber(tp,table.unpack(tab))
		local g=Duel.GetMatchingGroup(s.seqcheck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,num-1)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,id+40000,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.skcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) and Duel.GetTurnPlayer()==tp 
	and Duel.GetCurrentChain()<=0 and Duel.IsMainPhase() and e:GetHandler():GetCounter(0x4)>=13 and Duel.GetFlagEffect(tp,id+50000)==0
end
function s.skop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():RemoveCounter(tp,0x4,13,REASON_COST)~=0 then
		Duel.Hint(HINT_CARD,0,id)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,id+50000,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsReason(REASON_DESTROY) and rp==1-tp
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	local ct=e:GetLabelObject():GetLabel()
	Duel.SetTargetParam(ct*200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.dap(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x4)
	e:SetLabel(ct)
end