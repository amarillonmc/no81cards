--危机合约·险峻地势
function c79020008.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79020008.ztg)
	e1:SetOperation(c79020008.zop)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c79020008.mtop)
	c:RegisterEffect(e2) 
end
function c79020008.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,1000) then
		Duel.PayLPCost(tp,1000)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c79020008.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>1 end
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0)
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(90140980,0)) then
		local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,dis1)
		dis1=bit.bor(dis1,dis2)
		if c>2 and Duel.SelectYesNo(tp,aux.Stringid(90140980,0)) then
			local dis3=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,dis1)
			dis1=bit.bor(dis1,dis3)
	e:SetLabel(dis1)
end
end
end
function c79020008.zop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)<1 then return end
	--disable field
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c79020008.disop)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function c79020008.disop(e,tp)
	return e:GetLabel()
end
