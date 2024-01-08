--窃时姬 qni
local m=51341115
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa06),6,2,nil,nil,99)
	c:EnableReviveLimit()
	--be xyz 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.checkop)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
--be xyz
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_XYZ)
	local tc=g:GetFirst()
	local mg=nil
	while tc do
		if mg==nil then
			mg=tc:GetOverlayGroup()
		else
			mg:Merge(tc:GetOverlayGroup())
		end
		tc=g:GetNext()
	end
	mg:KeepAlive()
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(mg)
	e3:SetCountLimit(1)
	e3:SetOperation(cm.xyzop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_XYZ)
	if g:GetCount()<1 then return end
	local tc=g:GetFirst()
	local mg=nil
	while tc do
		if mg==nil then
			mg=tc:GetOverlayGroup()
		else
			mg:Merge(tc:GetOverlayGroup())
		end
		tc=g:GetNext()
	end
	if mg:GetCount()<1 then return end
	local ct=mg:Filter(cm.cfilter,nil,og):GetCount()
	if ct<1 then return end
	local xg=Duel.GetDecktopGroup(1-tp,ct)
	Duel.Overlay(e:GetHandler(),xg)
	og:Clear()
	e:Reset()
end
function cm.cfilter(c,og)
	return not og:IsContains(c)
end
--
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local a1=g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and Duel.GetFlagEffect(tp,m)==0
	local a2=g:IsExists(Card.IsType,1,nil,TYPE_SPELL) and Duel.GetFlagEffect(tp,m+1)==0
	local a3=g:IsExists(Card.IsType,1,nil,TYPE_TRAP) and Duel.GetFlagEffect(tp,m+2)==0
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and (a1 or a2 or a3) end
	local off=1
	local ops={}
	local opval={}
	if a1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if a2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if a3 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local tg=nil
	if opval[op]==1 then
		tg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	if opval[op]==2 then
		tg=g:Filter(Card.IsType,nil,TYPE_SPELL)
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	end
	if opval[op]==3 then
		tg=g:Filter(Card.IsType,nil,TYPE_TRAP)
		Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Remove(tg,POS_FACEDOWN,REASON_COST)
	e:SetLabel(tg:GetCount())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if ct==1 and Duel.GetDecktopGroup(1-tp,1):GetCount()>0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_DECK,1,1,nil):GetFirst()
		Duel.Overlay(c,tc)
	end
	if ct>=3 and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		Duel.Overlay(c,tc)
	end
end