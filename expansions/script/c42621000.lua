--学园孤岛 惠飞须泽胡桃
local cm,m=GetID()

function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
    --pzone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--leftp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.lpcost)
	e2:SetTarget(cm.lptg)
	e2:SetOperation(cm.lpop)
	c:RegisterEffect(e2)
	--rightp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(cm.rpcost)
	e3:SetOperation(cm.rpop)
	c:RegisterEffect(e3)
end

function cm.costcfilterg(c,tp)
    return c:IsCode(42621009) and (c:IsControler(tp) or c:IsFaceup())
end

function cm.costcfilter(g,tp)
    return g:IsExists(cm.costcfilterg,1,nil,tp)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,0x200,0x200,c)
	if chk==0 then return c:IsReleasable() and g:CheckSubGroup(cm.costcfilter,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	g=g:SelectSubGroup(tp,cm.costcfilter,false,2,2,tp)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(cm.adjustop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_MAX_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(cm.mvalue)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MAX_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(cm.svalue)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetValue(cm.aclimit)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SSET)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetTarget(cm.setlimit)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
	Duel.AdjustAll()
end

function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local c2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if c1>4 or c2>4 then
		local g=Group.CreateGroup()
		if c1>4 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,c1-4,c1-4,nil)
			g:Merge(g1)
		end
		if c2>4 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local g2=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_ONFIELD,0,c2-4,c2-4,nil)
			g:Merge(g2)
		end
		Duel.SendtoGrave(g,REASON_RULE)
		Duel.Readjust()
	end
end

function cm.mvalue(e,fp,rp,r)
	return 4-Duel.GetFieldGroupCount(fp,LOCATION_SZONE,0)
end

function cm.svalue(e,fp,rp,r)
	local ct=4
	for i=0,4 do
		if Duel.GetFieldCard(fp,LOCATION_SZONE,i) then ct=ct-1 end
	end
	return ct-Duel.GetFieldGroupCount(fp,LOCATION_MZONE,0)
end

function cm.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	if re:IsActiveType(TYPE_FIELD) then
		return not Duel.GetFieldCard(tp,LOCATION_FZONE,0) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>3
	elseif re:IsActiveType(TYPE_PENDULUM) then
		return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>3
	end
	return false
end

function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD) and not Duel.GetFieldCard(tp,LOCATION_FZONE,0) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>3
end

function cm.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lpck0=Duel.GetLocationCount(tp,0x08,tp,0x1,0x01)>0
	local lpck1=Duel.GetLocationCount(1-tp,0x08,tp,0x1,0x01)>0
	if chk==0 then return not c:IsForbidden() and (lpck0 or lpck1) end
	local lpck
	if lpck0 and lpck1 then
		lpck=math.abs(Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))-tp)
	else
		if lpck0 then
			lpck=tp
		else
			lpck=1-tp
		end
	end
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetValue(0x10001000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	Duel.RegisterEffect(e2,tp)
	Duel.AdjustAll()
	Duel.MoveToField(c,tp,lpck,0x200,POS_FACEUP,true)
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
	e2:Reset()
end

function cm.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0x01,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0x01,0,nil)
	if #g>0 then
		g=g:RandomSelect(tp,1)
        local c=e:GetHandler()
		if Duel.SendtoHand(g,nil,REASON_EFFECT) and c:GetFlagEffect(m)~=0 then
			c:ResetFlagEffect(m)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
            e1:SetRange(0x200)
			e1:SetTargetRange(1,0)
			e1:SetValue(0)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
			c:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_LPCOST_CHANGE)
			c:RegisterEffect(e3,true)
		end
	end
end

function cm.rpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lpck0=Duel.GetLocationCount(tp,0x08,tp,0x1,0x10)>0
	local lpck1=Duel.GetLocationCount(1-tp,0x08,tp,0x1,0x10)>0
	if chk==0 then return not c:IsForbidden() and (lpck0 or lpck1) end
	local lpck
	if lpck0 and lpck1 then
		lpck=math.abs(Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))-tp)
	else
		if lpck0 then
			lpck=tp
		else
			lpck=1-tp
		end
	end
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetValue(0x01000100)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	Duel.RegisterEffect(e2,tp)
	Duel.AdjustAll()
	Duel.MoveToField(c,tp,lpck,0x200,POS_FACEUP,true)
	e2:Reset()
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
end

function cm.rpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(m)~=0 then
		c:ResetFlagEffect(m)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
        e2:SetRange(0x200)
        e2:SetCode(EVENT_CHAINING)
        e2:SetOperation(cm.chainop)
        e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e2,true)
    end
end

function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(cm.chainlm)
end

function cm.chainlm(e,rp,tp)
	return not e:GetHandler():IsLocation(0x41)
end