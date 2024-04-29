--学园孤岛 丈枪由纪
local cm,m=GetID()

function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--pzone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
    --leftp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
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
    return c:IsCode(42621000) and (c:IsControler(tp) or c:IsFaceup())
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
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(cm.chainop2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function cm.chainop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsType(0x6) and rc:IsFaceup() and rc:IsOnField() and not rc:IsLocation(0x200) and rc:IsCanTurnSet() then
		if rc:IsStatus(STATUS_LEAVE_CONFIRMED) then
			rc:CancelToGrave()
		end
		if rc:IsLocation(0x04) then
			Duel.ChangePosition(rc,POS_FACEDOWN_DEFENSE)
		end
		if rc:IsLocation(0x08) then
			Duel.ChangePosition(rc,POS_FACEDOWN)
		end
		if rc:IsOnField() and rc:IsFacedown() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1)
            Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,0,0)
		end
	end
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
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,0x208)
end

function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0x01,0,nil)
    if #g>0 then
        g=g:RandomSelect(tp,1)
        if Duel.SendtoHand(g,nil,REASON_EFFECT) then
            local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x200,0x200,e:GetHandler())
            if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
                dg=dg:Select(tp,1,1,nil)
                Duel.HintSelection(dg)
                Duel.SendtoDeck(dg,tp,2,REASON_EFFECT)
            end
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
	e2:SetCode(EVENT_REMOVE)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_LEAVE_GRAVE)
	Duel.RegisterEffect(e3,tp)
	Duel.AdjustAll()
end

function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
    local tograven=Duel.GetFieldGroupCount(tp,0,0x20)-Duel.GetFieldGroupCount(tp,0,0x10)
    if tograven<=0 then return false end
    local deckg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,0x01,nil)
    local extrag=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,0x40,nil)
    local handg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,0x02,nil)
    local deckgn,extragn,handgn=#deckg,#extrag,#handg
    if deckgn+extragn+handgn==0 then
        return false
    else
        local g=Group.CreateGroup()
        if tograven<=deckgn then
            g=deckg:RandomSelect(1-tp,tograven)
        elseif tograven<=deckgn+extragn then
            g=extrag:RandomSelect(1-tp,tograven-deckgn)
            g:Merge(deckg)
        elseif tograven<deckgn+extragn+handgn then
            g=handg:RandomSelect(1-tp,tograven-deckgn-extragn)
            g:Merge(deckg)
            g:Merge(extrag)
        else
            g=deckg:__add(extrag:__add(handg))
        end
        Duel.SendtoGrave(g,REASON_RULE)
        local c=e:GetHandler()
        local g1=g:Filter(Card.IsLocation,nil,0x10)
        if #g1>0 then
            g1:KeepAlive()
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetTargetRange(1,1)
            e1:SetLabelObject(g1)
            e1:SetTarget(cm.sumlimit)
            e1:SetReset(RESET_PHASE+PHASE_END)
            Duel.RegisterEffect(e1,tp)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_CANNOT_REMOVE)
            e2:SetValue(1)
            Duel.RegisterEffect(e2,tp)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_CANNOT_TRIGGER)
            e3:SetReset(RESET_PHASE+PHASE_END)
            for tc in aux.Next(g1) do
                tc:RegisterEffect(e3,true)
            end
        end
        Duel.Readjust()
    end
end

function cm.sumlimit(e,c)
	return e:GetLabelObject():IsContains(c)
end