--学园孤岛 若狭悠里
local cm,m=GetID()

function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--pzone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
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
    return c:IsCode(42621006) and (c:IsControler(tp) or c:IsFaceup())
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

function cm.tgcfilter2(c)
	return c:IsAbleToDeck() and c:IsFaceup()
end

function cm.tgcfilter(tp,locc)
	if locc~=0x40 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,locc,1,nil)
	else
		return Duel.IsExistingMatchingCard(cm.tgcfilter2,tp,0,locc,1,nil)
	end
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.tgcfilter(tp,0x30) or cm.tgcfilter(tp,0x40) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,math.max(Duel.GetFieldGroupCount(tp,0,0x10),Duel.GetFieldGroupCount(tp,0,0x20),Duel.GetMatchingGroupCount(cm.tgcfilter2,tp,0,0x40,nil)),1-tp,0x70)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local b1=cm.tgcfilter(tp,0x10)
	local b2=cm.tgcfilter(tp,0x20)
	local b3=cm.tgcfilter(tp,0x40)
	if b1 or b2 or b3 then
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,5)},{b2,aux.Stringid(m,6)},{b3,aux.Stringid(m,7)})
		if op==1 then
			Duel.SendtoDeck(Duel.GetFieldGroup(tp,0,0x10),nil,2,REASON_EFFECT)
		elseif op==2 then
			Duel.SendtoDeck(Duel.GetFieldGroup(tp,0,0x20),nil,2,REASON_EFFECT)
		elseif op==3 then
			Duel.SendtoDeck(Duel.GetMatchingGroup(Card.IsFaceup,tp,0,0x40,nil),nil,2,REASON_EFFECT)
		end
	end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_TO_HAND)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,1)
	e0:SetTarget(cm.thlimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end

function cm.thlimit(e,c,tp,re)
	return (not re) or (not re:IsActivated())
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
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e1:SetTargetRange(1,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetValue(0)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_ATTACK_FINAL)
			Duel.RegisterEffect(e2,tp)
            local e3=e1:Clone()
            e3:SetTargetRange(0,1)
            Duel.RegisterEffect(e3,1-tp)
            local e4=e2:Clone()
            e4:SetTargetRange(0,1)
            Duel.RegisterEffect(e4,1-tp)
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
        e2:SetCode(EVENT_CHAINING)
        e2:SetRange(0x200)
        e2:SetOperation(cm.chainop)
        e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e2,true)
    end
end

function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==2 then
		Duel.SetChainLimit(cm.chainlm)
	end
end

function cm.chainlm(e,rp,tp)
	return tp==rp
end