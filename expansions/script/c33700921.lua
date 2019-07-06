--水晶魔法小妖精 布里吉特
function c33700921.initial_effect(c)
	--ss
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700921,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCost(c33700921.cost)
	e1:SetOperation(c33700921.operation)
	c:RegisterEffect(e1)   
	--Revive
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700921,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e) return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=0 end)
	e2:SetTarget(c33700921.thtg)
	e2:SetOperation(c33700921.thop)
	c:RegisterEffect(e2) 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_DECK)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(function(e) return e:GetHandler():IsFaceup() end)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	local e0=e4:Clone()
	e0:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e0)
	if c33700921.counter==nil then
		c33700921.counter=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_RECOVER)
		e3:SetOperation(c33700921.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c33700921.addcount(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,33700921,RESET_PHASE+PHASE_END,0,1)
end
function c33700921.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(33700921)>0
		and c:IsAbleToDeck() and Duel.GetFlagEffect(tp,33700921)<=0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c33700921.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,tp,0,REASON_EFFECT)
	if not c:IsLocation(LOCATION_DECK) then return end
	c:ReverseInDeck()
end
function c33700921.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c33700921.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)  
	e3:SetCondition(function(e,tp,eg,ep) return ep==tp end)
	e3:SetOperation(c33700921.dop)
	Duel.RegisterEffect(e3,tp)
	e:GetHandler():RegisterFlagEffect(33700921,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c33700921.dop(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.SelectYesNo(tp,aux.Stringid(33700921,0)) then
		Duel.Recover(tp,ev,REASON_EFFECT)
	end
	Duel.ChangeBattleDamage(ep,0)  
end

