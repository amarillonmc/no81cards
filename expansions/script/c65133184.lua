--WS-01 群星意志
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x838)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x838),3,5,s.lcheck)
	--Immunity & Counter Replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetCondition(s.exmcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.exmcon)
	e2:SetTarget(s.reptg)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
	--Chain Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.negcon)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
	local e32=Effect.CreateEffect(c)
	e32:SetDescription(aux.Stringid(id,0))
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e32:SetCode(EVENT_CHAINING)
	e32:SetRange(LOCATION_MZONE)
	e32:SetCondition(s.fcon)
	e32:SetOperation(s.fop)
	c:RegisterEffect(e32)
	--Column Wipe
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.exmcon)
	e4:SetTarget(s.wipetg)
	e4:SetOperation(s.wipeop)
	c:RegisterEffect(e4)

	--Effect 2: Attack Boost & Multi Attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START)
	e5:SetCondition(s.atkcon)
	e5:SetCost(s.atkcost)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function s.exmcon(e)
	return e:GetHandler():GetSequence()>=5
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and not e:GetHandler():IsReason(REASON_REPLACE)
		and e:GetHandler():IsCanAddCounter(0x838,1) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x838,1)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not s.exmcon(e) or c:GetFlagEffect(id)>2 then return false end
	return c:GetFlagEffect(id+1)>0 and rp==1-tp and Duel.IsChainDisablable(ev)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
		c:AddCounter(0x838,1)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.fcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function s.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function s.columnfilter(i,tp)
	local g=Group.CreateGroup()
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-i) then g=g+Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-i) end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-i) then g=g+Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-i) end
	if i==1 and Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) then g=g+Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if i==3 and Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) then g=g+Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
	return g
end
function s.wipetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local filter=0x60
	for i=0,4 do
		if Duel.GetFieldCard(tp,LOCATION_MZONE,i) or s.columnfilter(i,tp):GetCount()==0 then
			filter=filter|(1<<i)
		end
	end
	if chk==0 then return filter~=0x7f and e:GetHandler():IsCanAddCounter(0x838,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET) 
	local sel_zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,filter)
	Duel.SetTargetParam(sel_zone)
	Duel.Hint(HINT_ZONE,tp,sel_zone)
	local seq=math.log(sel_zone,2)
	local g=s.columnfilter(seq,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x838)
end
function s.wipeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel_zone=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local seq=math.log(sel_zone,2)
	local g=s.columnfilter(seq,tp)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and c:IsRelateToChain() and c:IsFaceup() then
		c:AddCounter(0x838,1)
	end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x838)>=3
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x838,3,REASON_COST) end
	local cnt = e:GetHandler():GetCounter(0x838)
	e:GetHandler():RemoveCounter(tp,0x838,cnt,REASON_COST)
	e:SetLabel(cnt)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cnt=e:GetLabel()
	if c:IsRelateToChain() and c:IsFaceup() then
		--ATK Up
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(cnt*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)		
		--Multi Attack
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(cnt-1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
