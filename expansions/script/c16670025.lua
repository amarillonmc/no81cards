--百变怪
local m=16670025
local cm=_G["c"..m]
function cm.initial_effect(c)
    --
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
    --
    local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	c:RegisterEffect(e11)
    --
	local e111=Effect.CreateEffect(c)
	e111:SetType(EFFECT_TYPE_SINGLE)
	e111:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	c:RegisterEffect(e111)
	--
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_MONSTER_SSET)
	e12:SetValue(TYPE_CONTINUOUS+TYPE_TRAP+TYPE_QUICKPLAY+TYPE_SPELL)
	c:RegisterEffect(e12)
	--
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetCode(EFFECT_REMOVE_TYPE)
	e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e22:SetRange(LOCATION_ONFIELD+LOCATION_HAND)
	--e22:SetCondition(aux.TRUE)
	e22:SetValue(TYPE_PENDULUM)
	--c:RegisterEffect(e22)
	--魔法发动
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DAMAGE_STEP)
	--
	--e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	--e2:SetLabel(m)
	e2:SetCondition(cm.backon4)
	e2:SetCost(cm.cost1)
	e2:SetTarget(cm.target)
    e2:SetOperation(cm.backop2)
	c:RegisterEffect(e2)
	local e6=e2:Clone()
	e6:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e6:SetCondition(cm.backon3)
	e6:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e6)
	local e27=e2:Clone()
	e27:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e27:SetRange(LOCATION_SZONE)
	e27:SetCondition(aux.TRUE)
	e27:SetCode(m+3)
	e27:SetCost(cm.cost)
	c:RegisterEffect(e27)
	local ez=Effect.CreateEffect(c)
	ez:SetDescription(aux.Stringid(m,2))
	ez:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ez:SetCode(EVENT_FREE_CHAIN)
	ez:SetRange(LOCATION_HAND)
	ez:SetLabelObject(e27)
	ez:SetCondition(cm.con)
	ez:SetOperation(cm.op)
	c:RegisterEffect(ez)
	local et=ez:Clone()
	et:SetCode(EVENT_CHAINING)
	et:SetCondition(cm.con1)
	--c:RegisterEffect(et)
    --变回去
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(cm.backon)
	e0:SetOperation(cm.backop)
	c:RegisterEffect(e0)
	local e00=e0:Clone()
	e00:SetLabelObject(e2)
	e00:SetCondition(cm.backon2)
	e00:SetOperation(cm.backop3)
	c:RegisterEffect(e00)
	--local e000=e0:Clone()
	--e000:SetCode(EVENT_MOVE)
	--c:RegisterEffect(e000)
	local e0000=e0:Clone()
	e0000:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0000:SetCode(EVENT_MOVE)
	e0000:SetLabelObject(e2)
	e0000:SetCondition(cm.backon2)
	e0000:SetOperation(cm.backop3)
	--c:RegisterEffect(e0000)
    --[[
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(cm.dp)
	c:RegisterEffect(e4)
	]]--
	local e16=Effect.CreateEffect(c)
	e16:SetCategory(CATEGORY_TOGRAVE)
	e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e16:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e16:SetRange(0xffff)
	e16:SetCode(EVENT_LEAVE_FIELD)
	--e6:SetCountLimit(1,m)
	--e16:SetLabelObject(e2)
	e16:SetCondition(cm.spcon)
	e16:SetOperation(cm.spop)
	c:RegisterEffect(e16)
	local e=e16:Clone()
	e:SetCode(EVENT_CHAIN_DISABLED)
	e:SetCondition(cm.spcon1)
	e:SetRange(0xffff)
	c:RegisterEffect(e)
	--local e22=e6:Clone()
	--e22:SetCode(EVENT_CUSTOM+m)
	--e22:SetLabel(m)
	--e22:GetLabelObject()
	--e22:SetCondition(cm.spcon2)
	--e22:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_GRAVE)
	--c:RegisterEffect(e22)
	--[[
	local t=Duel.ReadCard(m,CARDDATA_TYPE)
	Card.SetCardData(c,CARDDATA_TYPE,TYPE_CONTINUOUS+TYPE_TRAP+TYPE_QUICKPLAY+TYPE_SPELL+TYPE_EFFECT+TYPE_MONSTER+TYPE_PENDULUM)
	]]--[[
	local e44=Effect.CreateEffect(c)
	e44:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e44:SetCode(EVENT_LEAVE_FIELD_P)
	e44:SetLabelObject(e2)
	e44:SetOperation(cm.damp)
	c:RegisterEffect(e44)
	]]--魔法变
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetLabelObject(e2)
        ge1:SetTargetRange(1,1)
        ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        ge1:SetTarget(cm.actarget)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local e7=ge1:Clone()
		e7:SetLabelObject(e6)
		Duel.RegisterEffect(e7,0)
		--怪兽发动
		local e17=Effect.CreateEffect(c)
		e17:SetDescription(aux.Stringid(m,4))
		e17:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DAMAGE_STEP)
		e17:SetType(EFFECT_TYPE_QUICK_O)
		e17:SetCode(EVENT_FREE_CHAIN)
		e17:SetRange(LOCATION_HAND)
		e17:SetCondition(cm.syncon)
		e17:SetCost(cm.cost7)
		e17:SetTarget(cm.hsptg)
		e17:SetOperation(cm.synop)
		c:RegisterEffect(e17)
		local e19=e17:Clone()
		e19:SetCode(EVENT_CHAINING)
		e19:SetCondition(cm.syncon2)
		c:RegisterEffect(e19,true)
		--怪兽变
		local ge13=Effect.CreateEffect(c)
		ge13:SetType(EFFECT_TYPE_FIELD)
		ge13:SetCode(EFFECT_ACTIVATE_COST)
		ge13:SetLabelObject(e17)
        ge13:SetTargetRange(1,1)
        ge13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        ge13:SetTarget(cm.actarget)
		ge13:SetOperation(cm.checkop2)
		Duel.RegisterEffect(ge13,0)
		local e37=ge13:Clone()
		e37:SetLabelObject(e19)
		Duel.RegisterEffect(e37,0)
    if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		--ge2:SetLabelObject(e2)
		ge2:SetOperation(cm.checkop1)
		Duel.RegisterEffect(ge2,0)
		--迷惑
		local ge12=Effect.CreateEffect(c)
		ge12:SetType(EFFECT_TYPE_FIELD)
		ge12:SetCode(EFFECT_ACTIVATE_COST)
        ge12:SetTargetRange(1,1)
        ge12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge12:SetTarget(cm.spcon12)
		ge12:SetOperation(cm.dp1)
		Duel.RegisterEffect(ge12,0)
		--
	end
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function cm.spfilter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOriginalCode()~=m
end
function cm.dp(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then
		e:SetLabelObject(e:GetHandler())
	end
end
function cm.dp1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject():GetHandler()
	c:SetEntityCode(c:GetOriginalCode(),true)
	Duel.Readjust()
end
function cm.checkop1(e,tp,eg,ep,ev,re,r,rp)
	if not rp or not ev or not re then
		return false
	end
	local c=re:GetHandler()
	tp=c:GetControler()
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	--[[
	if e:GetLabelObject():IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetLabelObject():SetType(EFFECT_TYPE_QUICK_O)
	end
	]]--
	if c:GetFlagEffect(m+1)~=0 and dp==1-tp then
		local b1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(m,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(m,1)
			opval[off-1]=2
			off=off+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			local g=Duel.SelectMatchingCard(tp,cm.sptg,tp,0,LOCATION_HAND,1,1,nil)
			Duel.SendtoGrave(g,TYPE_EFFECT)
		elseif opval[op]==2 then
			local g=Duel.SelectMatchingCard(tp,cm.sptg,tp,0,LOCATION_ONFIELD,1,3,nil)
			Duel.SendtoGrave(g,TYPE_EFFECT)
		end
	end
end
function cm.con(e,tp)
	Duel.DisableActionCheck(true)
	local dc=Duel.CreateToken(tp,m+1)
	local res=dc:GetActivateEffect():IsActivatable(tp,false,false)
	Duel.DisableActionCheck(false)
	return res and Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL
	and Duel.GetCurrentPhase()~=PHASE_DAMAGE-- and Duel.GetCurrentPhase()~=PHASE_BATTLE_STEP
	and Duel.GetFlagEffect(tp,m+2)==0
end
function cm.con1(e,tp)
	Duel.DisableActionCheck(true)
	local dc=Duel.CreateToken(tp,m+1)
	local res=dc:GetActivateEffect():IsActivatable(tp,false,false)
	Duel.DisableActionCheck(false)
	return res and Duel.SelectYesNo(tp,aux.Stringid(m,3))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--c:RegisterFlagEffect(m+id,RESET_CHAIN,0,1)
	Duel.RegisterFlagEffect(tp,m+2,RESET_EVENT+RESET_CHAIN+EVENT_CHAINING,0,1)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,0xff,0,1,1,c):GetFirst()
    c:RegisterFlagEffect(m,0,0,1)
    c:SetEntityCode(g:GetOriginalCode(),true)
	local te,ceg,cep,cev,cre,cr,crp=g:CheckActivateEffect(false,true,true)
	--
	if not c:IsType(TYPE_FIELD) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		Duel.RaiseEvent(c,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
	if c:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_CONTINUOUS+TYPE_TRAP+TYPE_QUICKPLAY+TYPE_SPELL)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		c:RegisterEffect(e1,true)
	end
	if not c:IsType(TYPE_CONTINUOUS) then c:CancelToGrave(false) end
	if te~=nil and te:GetProperty()~=nil and bit.band(te:GetProperty(),EFFECT_FLAG_CARD_TARGET)~=0 then
		e:GetLabelObject():SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if te~=nil and te:GetCategory()~=nil then
		--if tg~=nil then e:GetLabelObject():SetTarget(te:GetTarget()) end
		e:GetLabelObject():SetCategory(te:GetCategory())
	end
    c:RegisterFlagEffect(m+1,0,0,1)
	--
	--local t=Duel.ReadCard(m,CARDDATA_TYPE)
	--Card.SetCardData(c,CARDDATA_TYPE,TYPE_CONTINUOUS+TYPE_TRAP+TYPE_QUICKPLAY+TYPE_SPELL)
	--
	--
	e:GetLabelObject():SetLabelObject(g)
	Duel.RaiseSingleEvent(e:GetHandler(),m+3,re,r,tp,tp,ev)
end
--魔法变
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetLabelObject():GetHandler()
    tp=e:GetLabelObject():GetHandler():GetControler()
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,0xff,0,1,1,c):GetFirst()
    c:RegisterFlagEffect(m,0,0,1)
    c:SetEntityCode(g:GetOriginalCode(),true)
	local te,ceg,cep,cev,cre,cr,crp=g:CheckActivateEffect(false,true,true)
	--
	if c:IsLocation(LOCATION_HAND) and e:GetLabelObject():IsHasType(EFFECT_TYPE_QUICK_O) and not
	e:GetLabelObject():IsHasType(EFFECT_TYPE_ACTIVATE) then
		if not c:IsType(TYPE_FIELD) then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.RaiseEvent(c,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
		if c:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_CONTINUOUS+TYPE_TRAP+TYPE_QUICKPLAY+TYPE_SPELL)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			c:RegisterEffect(e1,true)
		end
		e:GetLabelObject():SetType(EFFECT_TYPE_ACTIVATE)
		if not c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_FIELD) then c:CancelToGrave(false) end
	end
	if te~=nil and te:GetProperty()~=nil and bit.band(te:GetProperty(),EFFECT_FLAG_CARD_TARGET)~=0 then
		e:GetLabelObject():SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if te~=nil and te:GetCategory()~=nil then
		--if tg~=nil then e:GetLabelObject():SetTarget(te:GetTarget()) end
		e:GetLabelObject():SetCategory(te:GetCategory())
	end
	--[[
	e:GetLabelObject():SetDescription(aux.Stringid(m,10))
	if te~=nil and te:GetDescription()~=nil then
		e:GetLabelObject():SetDescription(te:GetDescription())
	end
	]]--
	--
    c:RegisterFlagEffect(m+1,0,0,1)
	--
	--local t=Duel.ReadCard(m,CARDDATA_TYPE)
	--Card.SetCardData(c,CARDDATA_TYPE,TYPE_CONTINUOUS+TYPE_TRAP+TYPE_QUICKPLAY+TYPE_SPELL)
	--
	--
	e:GetLabelObject():SetLabelObject(g)
	e:GetLabelObject():SetLabel(g:GetOriginalCode())
    --Duel.AdjustAll()
end
--怪兽变
function cm.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local ha=e:GetLabelObject()
    local c=ha:GetHandler()
    tp=ha:GetHandler():GetControler()
	local tp2=tp
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,0xff,0,1,1,c):GetFirst()
    c:RegisterFlagEffect(m,0,0,1)
	if c:IsDiscardable() and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		c:RegisterFlagEffect(m+2,0,0,1)
	end
	c:RegisterFlagEffect(m+3,0,0,1)
    c:SetEntityCode(g:GetOriginalCode(),true)
	local token=Duel.CreateToken(tp2,g:GetOriginalCode())
	local mt=getmetatable(token)
	local te=nil
	local rx=nil
	cm.xe=nil
	if Duel.CheckEvent(EVENT_CHAINING) then
		rx=true
		cm.jc=EVENT_CHAINING
		local eg1,ep1,ev1,re1,r1,rp1=Duel.CheckEvent(EVENT_CHAINING,true)
		cm.x1,cm.x2,cm.x3,cm.x4,cm.x5,cm.x6,cm.x7,cm.x8=ha,tp2,eg1,ep1,ev1,re1,r1,rp1
	else--if Duel.CheckEvent(EVENT_FREE_CHAIN) then
		cm.jc=EVENT_FREE_CHAIN
		rx=true
		local eg1,ep1,ev1,re1,r1,rp1=Duel.CheckEvent(EVENT_FREE_CHAIN,true)
		cm.x1,cm.x2,cm.x3,cm.x4,cm.x5,cm.x6,cm.x7,cm.x8=ha,tp2,eg1,ep1,ev1,ha,r1,rp1
	end
	cm.reg =Card.RegisterEffect
	Card.RegisterEffect = cm.reg3
	if mt.initial_effect then
		mt.initial_effect(c)
	end
	Card.RegisterEffect = cm.reg
	--
	if cm.xe~=nil then
		te=cm.xe
	end
	if te~=nil and te:GetProperty()~=nil and bit.band(te:GetProperty(),EFFECT_FLAG_CARD_TARGET)~=0 then
		ha:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if te~=nil and te:GetCategory()~=nil then
		ha:SetCategory(te:GetCategory())
	end
    c:RegisterFlagEffect(m+1,0,0,1)
	--
	ha:SetLabelObject(te)
	--[[
	local to={cm.x1,cm.x2,cm.x3,cm.x4,cm.x5,cm.x6,cm.x7,cm.x8}
	for tz,ta in ipairs(to) do
		to[tz]=nil
	end
	]]--
	Duel.Readjust()
	cm.xe=nil
end
function cm.reg2(c,e,ob)
	local b=ob or false
	--
	if e:IsHasType(EFFECT_TYPE_QUICK_F) then
		e:SetType((e:GetType()-EFFECT_TYPE_QUICK_F)|EFFECT_TYPE_QUICK_O)
		local flag1,flag2=e:GetProperty()
		e:SetProperty(flag1|EFFECT_FLAG_DELAY,flag2)
	end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		e:SetType((e:GetType()-EFFECT_TYPE_TRIGGER_F)|EFFECT_TYPE_TRIGGER_O)
	end
	--
	e:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e:SetOperation(cm.pr)
	local qi,da=e:GetCountLimit()
	if qi~=nil and da==nil then
		e:SetCountLimit(qi)
	elseif qi~=nil and da~=nil then
		e:SetCountLimit(qi,m+da)
	end
	if not e:IsActivated() then e:Reset()
	else
		cm.reg(c,e,b)
	end
end
function cm.reg3(c,e,ob)
	local b=ob or false
	--
	local chk=0
	if e:GetRange()~=nil and bit.band(e:GetRange(),LOCATION_HAND)~=0
	-- and (e:GetCode()~=nil or bit.band(cm.jc,e:GetCode())~=0)
	--and (e:GetCondition()==nil or e:GetCondition()(cm.x1,cm.x2,cm.x3,cm.x4,cm.x5,cm.x6,cm.x7,cm.x8))
	and e:GetTarget()~=nil and e:GetTarget()(cm.x1,cm.x2,cm.x3,cm.x4,cm.x5,cm.x6,cm.x7,cm.x8,chk) then
		cm.xe=e
	else
		e:Reset()
	end
end
function cm.pr(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.actarget(e,te,tp)
    local c=te:GetHandler()
	local e1=e:GetLabelObject()
	return c:IsOriginalCodeRule(m) and e1==te-- and ((te:IsHasType(EFFECT_TYPE_QUICK_O) and c:IsLocation(LOCATION_HAND)) or
	--(te:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsLocation(LOCATION_SZONE)))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	tp=c:GetControler()
	if chk==0 then
		--if e:GetLabel()==0 then return false end
		--e:SetLabel(0)
		return true
	end
	--e:SetLabel(0)
	--c:CreateEffectRelation(e)
	if e:GetLabel()~=nil then
		local token=Duel.CreateToken(tp,e:GetLabel())
		local te,ceg,cep,cev,cre,cr,crp=token:CheckActivateEffect(false,true,true)
		if te~=nil then
			local tg=te:GetTarget()
			if te:GetLabelObject()~=nil then e:SetLabelObject(te:GetLabelObject()) end
			--if te:GetCategory()~=nil then e:SetCategory(te:GetCategory()) end
			if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp) end
		end
	end
	--Duel.RaiseEvent(c,EVENT_CHAINING,te,0,tp,tp,Duel.GetCurrentChain())
end
function cm.backop2(e,tp,eg,ep,ev,re,r,rp)
	--
	local c=e:GetHandler()
	c:CancelToGrave(true)
	if c:IsRelateToEffect(e) and not c:IsType(TYPE_CONTINUOUS) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_CONTINUOUS+TYPE_TRAP+TYPE_QUICKPLAY+TYPE_SPELL)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		c:RegisterEffect(e1,true)
	end
	--
end
function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)~=0 and c:GetFlagEffect(m+1)~=0 and c:GetFlagEffect(m+3)==0
end
function cm.backon2(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	return e1:GetCategory()~=nil or e1:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.backon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		return false
	end
    return true
end
function cm.backon4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOriginalCode()~=m or tp==nil then
		return false
	end
	Duel.DisableActionCheck(true)
	local dc=Duel.CreateToken(tp,m+1)
	local res=dc:GetActivateEffect():IsActivatable(tp,false,false)
	Duel.DisableActionCheck(false)
    return ((Duel.GetCurrentPhase()~=PHASE_END and Duel.GetCurrentPhase()~=PHASE_BATTLE_START
	and Duel.GetCurrentPhase()~=PHASE_STANDBY and Duel.GetCurrentPhase()~=PHASE_DRAW and
	(Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2 and Duel.GetTurnPlayer()==tp)
	)--and Duel.GetCurrentPhase()~=PHASE_BATTLE_STEP)
	or Duel.GetCurrentChain()~=0)-- or Duel.GetCurrentPhase()~=PHASE_BATTLE_STEP
	and res
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    c:ResetFlagEffect(m)
    c:ResetFlagEffect(m+1)
	c:RegisterFlagEffect(m+1,0,0,1)
	c:SetEntityCode(m)
	--if c:IsFacedown() then
	--	Duel.ConfirmCards(tp,Group.FromCards(c))
	--	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	--end
end
function cm.backop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local e1=e:GetLabelObject()
	e1:SetCategory(0)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(0)
end
function cm.backop4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local e1=e:GetLabelObject()
	if e1:GetCategory()~=nil or e1:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e1:SetCategory(0)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetProperty(0)
	end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	tp=c:GetControler()
	if chk==0 then-- e:SetLabel(1) 
		return true--(c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0) or (c:IsLocation(LOCATION_SZONE) and
		--c:IsFacedown()) 
	end
	local c2=e:GetLabelObject()
	if c2~=nil then
		if c2:GetFlagEffect(m+1)~=0 then
			c2=Duel.CreateToken(tp,c2:GetOriginalCode())
		end
		local te,ceg,cep,cev,cre,cr,crp=c2:CheckActivateEffect(false,false,true)
		if te~=nil then
			local tg=te:GetCost()
			--if te:GetCategory()~=nil then e:SetCategory(te:GetCategory()) end
			if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp) end
		end
		--if c2:GetFlagEffect(m+1)==0 then
			local token=Duel.CreateToken(tp,c2:GetOriginalCode())
			local mt=getmetatable(token)
			cm.reg =Card.RegisterEffect
			Card.RegisterEffect = cm.reg2
			if mt.initial_effect then
				mt.initial_effect(c)
			end
			Card.RegisterEffect = cm.reg
		--end
	end
	--e:SetLabel(1)local e0000=e0:Clone()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(cm.backop4)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	e:SetType(EFFECT_TYPE_ACTIVATE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(cm.reset)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
	--
	local c2=e:GetLabelObject()
	if c2~=nil then
		if c2:GetFlagEffect(m+1)~=0 then
			c2=Duel.CreateToken(tp,c2:GetOriginalCode())
		end
		local te,ceg,cep,cev,cre,cr,crp=c2:CheckActivateEffect(false,false,true)
		if te~=nil then
			local tg=te:GetCost()
			--if te:GetCategory()~=nil then e:SetCategory(te:GetCategory()) end
			if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp) end
		end
		--if c2:GetFlagEffect(m+1)==0 then
			local token=Duel.CreateToken(tp,c2:GetOriginalCode())
			local mt=getmetatable(token)
			cm.reg =Card.RegisterEffect
			Card.RegisterEffect = cm.reg2
			if mt.initial_effect then
				mt.initial_effect(c)
			end
			Card.RegisterEffect = cm.reg
		--end
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e:Reset()
end
function cm.reset2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject():GetHandler()
	c:ResetFlagEffect(m+3)
	c:ResetFlagEffect(m)
	c:SetEntityCode(m)
	e:Reset()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil)
	return rp==1-tp and c:IsPreviousPosition(POS_FACEUP) and eg:IsContains(e:GetHandler()) and g1
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if not rp or not ev then
		return false
	end
	local dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER)
	if not dp then
		return false
	end
	local c=e:GetHandler()
	local g1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil)
	return rp==1-dp and re:GetHandler()==c and g1
end
function cm.spcon12(e,te,tp)
	local c=te:GetHandler()
	e:SetLabelObject(te)
	return c:IsLocation(LOCATION_HAND) and not c:IsOriginalCodeRule(m)-- and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil)
	return g1
end
function cm.sptg(c)
	return c:IsAbleToGrave()
end
function cm.damp(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetLabelObject():SetType(EFFECT_TYPE_QUICK_O)
	end
end
--怪兽效果发动
function cm.syncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.CheckEvent(EVENT_CHAINING) and c:GetFlagEffect(m+3)==0
end
function cm.syncon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m+3)==0
end
function cm.cost7(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if c:GetFlagEffect(m+2)~=0 then
		c:ResetFlagEffect(m+2)
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(cm.reset2)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function cm.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	if e:GetLabelObject()~=nil then e:GetLabelObject():GetTarget()(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.SelectMatchingCard(tp,cm.sptg,tp,0,LOCATION_HAND,1,1,nil)
		Duel.SendtoGrave(g,TYPE_EFFECT)
	elseif opval[op]==2 then
		local g=Duel.SelectMatchingCard(tp,cm.sptg,tp,0,LOCATION_ONFIELD,1,3,nil)
		Duel.SendtoGrave(g,TYPE_EFFECT)
	end
end
