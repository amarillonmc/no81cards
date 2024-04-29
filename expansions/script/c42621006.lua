--学园孤岛 直树美纪
local cm,m=GetID()

function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--pzone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
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
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RECOVER)
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
    return c:IsCode(42621003) and (c:IsControler(tp) or c:IsFaceup())
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

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,0x0c)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0x0c,0x0c,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0x0c,0x0c,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function cm.aclimit(e,re,tp)
	return re:IsActiveType(0x6) and not re:GetHandler():IsLocation(0x0c)
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
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,100+Duel.GetMatchingGroup(Card.IsFaceup,tp,0x200,0x200,nil):GetSum(Card.GetLeftScale)*1000)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0x01,0,nil)
    if #g>0 then
        g=g:RandomSelect(tp,1)
        if Duel.SendtoHand(g,nil,REASON_EFFECT) then
            local num=Duel.GetMatchingGroup(Card.IsFaceup,tp,0x200,0x200,nil):GetSum(Card.GetLeftScale)
            Duel.Recover(tp,100+num*1000,REASON_EFFECT)
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
end

function cm.rpop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(cm.adjustop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
	Duel.RegisterEffect(e2,tp)
	Duel.AdjustAll()
end

function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
    local removen=Duel.GetFieldGroupCount(tp,0,0x10)-Duel.GetFieldGroupCount(tp,0,0x20)
    if removen<=0 then return false end
    local deckg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,0x01,nil,0xa)
    local extrag=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,0x40,nil,0xa)
    local handg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,0x02,nil,0xa)
    local deckgn,extragn,handgn=#deckg,#extrag,#handg
    if deckgn+extragn+handgn==0 then
        return false
    else
        local g=Group.CreateGroup()
        if removen<=deckgn then
            g=deckg:RandomSelect(1-tp,removen)
        elseif removen<=deckgn+extragn then
            g=extrag:RandomSelect(1-tp,removen-deckgn)
            g:Merge(deckg)
        elseif removen<deckgn+extragn+handgn then
            g=handg:RandomSelect(1-tp,removen-deckgn-extragn)
            g:Merge(deckg)
            g:Merge(extrag)
        else
            g=deckg:__add(extrag:__add(handg))
        end
        Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
        Duel.Readjust()
    end
end