local m=42621000
local cm=_G["c"..m]

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

function cm.costcfilter(c,cscale)
	return c:IsReleasable() and c:GetCurrentScale()+cscale>0
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cscale=c:GetCurrentScale()
	if chk==0 then return c:IsReleasable() and Duel.IsExistingMatchingCard(cm.costcfilter,tp,0x200,0x200,1,c,cscale) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.costcfilter,tp,0x200,0x200,1,1,c,cscale)
	e:SetLabel((g:GetFirst():GetCurrentScale()+cscale)*1000)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,e:GetLabel(),REASON_EFFECT) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(0,1)
		e1:SetLabel(tp)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTarget(cm.splimit)
		Duel.RegisterEffect(e1,tp)
	end
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return targetp==e:GetLabel()
end

function cm.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lpck0=Duel.GetLocationCount(tp,0x08,tp,0x1,0x01)>0--Duel.GetLocationCount(tp,0x08,tp,0x1,0x01)>0
	local lpck1=Duel.GetLocationCount(1-tp,0x08,tp,0x1,0x01)>0--Duel.GetLocationCount(1-tp,0x08,tp,0x1,0x01)>0
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
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
			Duel.RegisterEffect(e2,tp)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_LPCOST_CHANGE)
			Duel.RegisterEffect(e3,tp)
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
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(cm.chainop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(cm.chainlm)
end

function cm.chainlm(e,rp,tp)
	return not e:GetHandler():IsLocation(0x41)
end