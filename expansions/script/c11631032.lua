--特制药·枪药
local m=11631032
local cm=_G["c"..m]
--strings
cm.tezhiyao=true 
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--register
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_ACTIVATE_COST)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)  
	e2:SetTargetRange(1,0)  
	e2:SetTarget(cm.actarget)  
	e2:SetCost(aux.TRUE)  
	e2:SetOperation(cm.costop)  
	c:RegisterEffect(e2)  
end

--activate
function cm.cfilter(c)
	return c.yaojishi and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function cm.atkfilter(c)
	return c:IsAttackPos() 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.atkfilter(chkc)  end  
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.atkfilter,tp,0,LOCATION_MZONE,1,nil) end 
	if c:GetFlagEffect(m)>0 then
		e:SetLabel(114514)
		c:ResetFlagEffect(m)
	end  
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,0) 
	Debug.Message('BOKI～')
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK)
	local g=Duel.SelectMatchingCard(tp,cm.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0  then  
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(math.ceil(tc:GetBaseAttack()/2))
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_MUST_ATTACK)
		e3:SetDescription(aux.Stringid(m,0))
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		tc:RegisterEffect(e3)
		if e:GetLabel()==114514 then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
			e5:SetCode(EVENT_LEAVE_FIELD)
			e5:SetOperation(cm.desop)
			tc:RegisterEffect(e5,true)
		end
	end  
end  
function desop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message('他憋死了（悲）')
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.distg)
	e1:SetLabelObject(c)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	e2:SetLabelObject(c)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	e:Reset()
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule()) and rp==1-tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end


--register
function cm.actarget(e,te,tp)  
	local tc=te:GetHandler()
	return tc==e:GetHandler() and tc:IsLocation(LOCATION_HAND) and tc:IsPublic()
end  
function cm.costop(e,tp,eg,ep,ev,re,r,rp) 
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1) 
end  

