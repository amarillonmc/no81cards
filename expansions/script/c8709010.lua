--端午节的觉醒数珠
function c8709010.initial_effect(c)
		  --xyz summon
	aux.AddXyzProcedure(c,nil,3,2,c8709010.ovfilter,aux.Stringid(8709010,0),2,c8709010.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c8709010.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c8709010.defval)
	c:RegisterEffect(e2) 

	--search limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8709010,1))
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CUSTOM+8709010)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,8709010)
	e1:SetCondition(c8709010.condition)
	e1:SetCost(c8709010.cost)
	e1:SetOperation(c8709010.operation)
	c:RegisterEffect(e1)
	if not c8709010.global_check then
		c8709010.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c8709010.regcon)
		ge1:SetOperation(c8709010.regop)
		Duel.RegisterEffect(ge1,0)
	end

end

function c8709010.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xafa) and not c:IsCode(8709010)
end
function c8709010.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,8709010)==0 end
	Duel.RegisterFlagEffect(tp,8709010,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c8709010.atkfilter(c)
	return c:IsSetCard(0xafa) and c:GetAttack()>=0
end
function c8709010.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709010.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c8709010.deffilter(c)
	return c:IsSetCard(0xafa) and c:GetDefense()>=0
end
function c8709010.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709010.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c8709010.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c8709010.regcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW then return false end
	local v=0
	if eg:IsExists(c8709010.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c8709010.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c8709010.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+8709010,re,r,rp,ep,e:GetLabel())
end
function c8709010.condition(e,tp,eg,ep,ev,re,r,rp)
	return ev==1-tp or ev==PLAYER_ALL
end
function c8709010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8709010.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,1)
	Duel.RegisterEffect(e2,tp)
end


