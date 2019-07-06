--诡异的光
function c11113133.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11113133.target1)
	e1:SetOperation(c11113133.operation)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,11113133)
	e2:SetCost(c11113133.cost)
	e2:SetTarget(c11113133.target2)
	e2:SetOperation(c11113133.operation)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
end
function c11113133.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetFlagEffect(tp,11113133)==0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 
	    and Duel.SelectYesNo(tp,94) then
		Duel.RegisterFlagEffect(tp,11113133,RESET_PHASE+PHASE_END,0,1)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c11113133.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11113133)==0 end
	Duel.RegisterFlagEffect(tp,11113133,RESET_PHASE+PHASE_END,0,1)
end
function c11113133.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
end
function c11113133.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if e:GetLabel()==0 or not c:IsRelateToEffect(e)
       or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(1-tp,70,71,72)
	local hd=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,hd)
	if (op==0 and not hd:IsExists(Card.IsType,1,nil,TYPE_MONSTER)) or (op==1 and not hd:IsExists(Card.IsType,1,nil,TYPE_SPELL)) 
	    or (op==2 and not hd:IsExists(Card.IsType,1,nil,TYPE_TRAP)) then
		if Duel.GetTurnPlayer()==tp then
		    --cannot inactivate/disable
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(11113133,0))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_INACTIVATE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_SZONE)
			e1:SetValue(c11113133.efilter)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_DISEFFECT)
			e2:SetRange(LOCATION_SZONE)
			e2:SetValue(c11113133.efilter)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2)
			--cannot disable
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_DISABLE)
			e3:SetRange(LOCATION_SZONE)
			e3:SetTargetRange(LOCATION_ONFIELD,0)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3)
		else
		    local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(11113133,1))
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e4:SetCode(EVENT_CHAIN_SOLVING)
			e4:SetRange(LOCATION_SZONE)
			e4:SetCondition(c11113133.negcon)
			e4:SetOperation(c11113133.negop)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e4)
		end
	end
	Duel.ShuffleHand(tp)
end
function c11113133.efilter(e,ct)
    local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp
end
function c11113133.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainDisablable(ev) 
end
function c11113133.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end