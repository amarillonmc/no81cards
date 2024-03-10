--永恒的约定
local m=16670030
local cm=_G["c"..m]
function cm.initial_effect(c)
    --
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,1))
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e10:SetCode(m+2)
	e10:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	--多次召唤
	local e101=Effect.CreateEffect(c)
	e101:SetType(EFFECT_TYPE_SINGLE)
	e101:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e101:SetCode(m+1)
	c:RegisterEffect(e101)
	--
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCountLimit(1)
	e1:SetOperation(cm.SpiritReturnReg)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
    local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	--c:RegisterEffect(e2)
	--
	local e81=Effect.CreateEffect(c)
	e81:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e81:SetType(EFFECT_TYPE_SINGLE)
	e81:SetCode(EFFECT_SPSUMMON_CONDITION)
	e81:SetValue(aux.FALSE)
	c:RegisterEffect(e81)
    --
    local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e11)
    --
    local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e22:SetCode(EVENT_SUMMON_SUCCESS)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e22:SetOperation(cm.cd)
	c:RegisterEffect(e22)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_ADJUST)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_ONFIELD+LOCATION_HAND)
	e4:SetOperation(cm.adop)
	c:RegisterEffect(e4)
	if not cm.ces then
		cm.ces=true
		cm.ec3=Card.IsDualState
		Card.IsDualState=cm.ec
		cm.ae2=Card.EnableDualState
		Card.EnableDualState=cm.ae
		cm.caa={}
		cm.caa[0]=false
		cm.caa[1]=false
		--[[
        cm.reg =Card.RegisterEffect
        Card.RegisterEffect = cm.reg2
		]]--
	end
end
function cm.SpiritReturnReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0xd6e0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.SpiritReturnConditionForced)
	e1:SetTarget(cm.SpiritReturnTargetForced)
	e1:SetOperation(cm.SpiritReturnOperation)
	c:RegisterEffect(e1)
end
function cm.SpiritReturnOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function cm.SpiritReturnConditionForced(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_CANNOT_TO_GRAVE)
end
function cm.SpiritReturnTargetForced(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cm.cd2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local hp=Duel.GetLP(tp)
	return hp<=0 and Duel.GetFlagEffect(tp,m)>=2 and Duel.GetTurnPlayer()==tp
end
function cm.cd1(e)
	local tp=e:GetLabel()
	return Duel.GetFlagEffect(tp,m)>=2
end
function cm.cd(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    Duel.RegisterFlagEffect(tp,m,0,0,1)
    local e112=c:IsHasEffect(EFFECT_DUAL_STATUS)
    if e112~=nil then
		local z=e112:GetHandler()
		--Duel.ConfirmCards(tp,z)
		if z==c then
			e112:Reset()
			local e12=c:IsHasEffect(m+2)
			if c:GetFlagEffect(m+2)==0 then
				c:RegisterFlagEffect(m+2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
				--[[
				local e10=Effect.CreateEffect(c)
				e10:SetDescription(aux.Stringid(m,1))
				e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e10:SetCode(m+2)
				e10:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e10:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e10)
				]]--
			end
		end
    end
    if cm.caa[c:GetControler()]~=true then
        cm.caa[c:GetControler()]=true
        local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
		e2:SetLabel(tp)
		e2:SetValue(1)
        e2:SetCondition(cm.cd1)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCountLimit(1)
        e1:SetTargetRange(1,0)
        e1:SetCondition(cm.cd2)
        e1:SetOperation(cm.cd3)
        Duel.RegisterEffect(e1,tp)
        local e11=Effect.CreateEffect(c)
        e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
        e11:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e11:SetCountLimit(1)
        e11:SetLabel(Duel.GetTurnCount())
        e11:SetCondition(cm.spcon)
        e11:SetOperation(cm.spop)
        Duel.RegisterEffect(e11,tp)
		local e22=Effect.CreateEffect(c)
		e22:SetType(EFFECT_TYPE_FIELD)
		e22:SetCode(EFFECT_UPDATE_ATTACK)
		e22:SetTargetRange(LOCATION_MZONE,0)
		e22:SetCondition(cm.atkcon)
		e22:SetTarget(aux.TargetBoolFunction(Card.IsCode,m))
		e22:SetValue(100000)
        Duel.RegisterEffect(e22,tp)
		--local e23=e22:Clone()
		local e31=Effect.CreateEffect(c)
		e31:SetType(EFFECT_TYPE_FIELD)
		e31:SetCode(EFFECT_DIRECT_ATTACK)
		e31:SetTargetRange(LOCATION_MZONE,0)
		e31:SetCondition(cm.atkcon)
		e31:SetTarget(aux.TargetBoolFunction(Card.IsCode,m))
		Duel.RegisterEffect(e31,tp)
		--
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetCondition(cm.atkcon)
		e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,m))
		e3:SetValue(cm.spop1)
		Duel.RegisterEffect(e3,tp)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		Duel.RegisterEffect(e5,tp)
		--
		local e119=Effect.CreateEffect(c)
        e119:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e119:SetCode(EVENT_PRE_BATTLE_DAMAGE)
        e119:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e119:SetCondition(cm.atkcon)
        e119:SetOperation(cm.spop1)
        --Duel.RegisterEffect(e119,tp)
    end
	local num=Duel.GetFlagEffect(tp,m)+1
	while Duel.IsPlayerAffectedByEffect(tp,m+3)~=nil do
		local o=Duel.IsPlayerAffectedByEffect(tp,m+3)
		o:Reset()
	end
	if num>12 then num=12 end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(m,num))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(m+3)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
end
function cm.cd3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local e1=Duel.GetFlagEffect(tp,m)
    if e1~=0 then
		Duel.ResetFlagEffect(tp,m)
		for i = 1,e1-1 do
			Duel.RegisterFlagEffect(tp,m,0,0,1)
		end
    end
	local num=Duel.GetFlagEffect(tp,m)+1
	while Duel.IsPlayerAffectedByEffect(tp,m+3)~=nil do
		local o=Duel.IsPlayerAffectedByEffect(tp,m+3)
		o:Reset()
	end
	if num>12 then num=12 end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(m,num))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(m+3)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_ATTACK)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetTurnPlayer()==tp
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end
function cm.spop1(e,p)
	local c=e:GetHandler()
	local num=c:GetAttack()
	local t=c:GetBattleTarget()
	local tp=1-c:GetControler()
	if t~=nil then
		num=num-t:GetAttack()
		tp=t:GetControler()
	end
	Duel.SetLP(tp,Duel.GetLP(tp)-num)
end
function cm.filsn(c)
	return c:IsOriginalSetCard(0x9b61) and c:IsType(TYPE_MONSTER) and c:GetFlagEffectLabel(m)==nil
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(m)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>=9
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e112=c:IsHasEffect(EFFECT_DUAL_STATUS)
    if e112~=nil then
		local z=e112:GetHandler()
		if z~=c then
			if e112:IsHasType(EFFECT_TYPE_FIELD) then
				if e112:GetTarget() then
					local con=e112:GetTarget()
					e112:SetTarget(function(e,c)
						return c:IsHasEffect(m+1)==nil
							and con(e,c)
						end)
				else e112:SetTarget(function(e,c)
					return c:IsHasEffect(m+1)==nil end)
				end
				local e12=c:IsHasEffect(m+2)
				if c:GetFlagEffect(m+2)==0 then
					c:RegisterFlagEffect(m+2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
				end
			elseif e112:GetCondition() then
				local con=e112:GetCondition()
				e112:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler():GetEquipTarget()
					return  c:IsHasEffect(m+1)==nil
						and con(e,tp,eg,ep,ev,re,r,rp) 
					end)
			else e112:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler():GetEquipTarget()
				return  c:IsHasEffect(m+1)==nil end)
			end
		end
    end
end
--判断二重
function cm.ec(c)
	local u=false
	local e12=c:IsHasEffect(m+2)
	if c:GetFlagEffect(m+2)~=0 or cm.ec3(c) then
		u=true
	end
	return u
end
function cm.ec2(e,tp,eg,ep,ev,re,r,rp,con)
	return c:IsHasEffect(m+1)==nil and con(c)
end
--赋予二重
function cm.ae(c)
	if c:IsHasEffect(m+1)==nil then
		return cm.ae2(c)
	end
	local e12=c:IsHasEffect(m+2)
	if c:GetFlagEffect(m+2)==0 then
		c:RegisterFlagEffect(m+2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	return nil
end
function cm.reg2(c,ie,ob)
	local b=ob or false
	if not c:GetOriginalType(TYPE_MONSTER) --and not c:IsType(TYPE_LINK+TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION)) 
		or not ie:IsHasType(EFFECT_DUAL_STATUS) or c:IsHasEffect(m+1)==nil then
		return cm.reg(c,ie,b)
	end
	local e12=c:IsHasEffect(m+2)
		if e12==nil then
			local e10=Effect.CreateEffect(c)
			e10:SetDescription(aux.Stringid(m,1))
			e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e10:SetCode(m+2)
			e10:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			return cm.reg(c,e10,b)
		end
	return nil
end