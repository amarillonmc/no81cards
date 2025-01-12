--Cry for me
function c12847502.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c12847502.condition)
	e1:SetCost(c12847502.cost)
	e1:SetOperation(c12847502.activate)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c12847502.effectfilter2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(c12847502.effectfilter2)
	c:RegisterEffect(e3)
	--cannot be destroyed
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--cannot set/activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SSET)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c12847502.setlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,0)
	e6:SetValue(c12847502.actlimit)
	c:RegisterEffect(e6)
end
function c12847502.condition(e,tp)
	local chain=Duel.GetCurrentChain()
	local flag=false
	for i=1,chain do
		local re=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if re:GetHandlerPlayer()==tp and re:IsActiveType(TYPE_MONSTER) then
			flag=true
		end 
	end
	return flag and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_FZONE,0,1,nil) and Duel.GetCurrentChain()>0 and e:GetHandler():IsLocation(LOCATION_HAND)
end
function c12847502.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chain=Duel.GetCurrentChain()
	local rg=Group.CreateGroup()
	for i=1,chain do
		local re=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local gc=re:GetHandler()
		if re:GetHandlerPlayer()==tp and gc:IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER) and gc:IsAbleToHandAsCost() then
			rg:AddCard(gc)
		end 
	end
	if chk==0 then return rg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=rg:Select(tp,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	e:SetLabel(g:GetFirst():GetCode())
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12847502,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(c12847502.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,5)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function c12847502.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then Duel.SendtoGrave(c,REASON_RULE) e:Reset() end
	
end
function c12847502.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c12847502.sumlimit)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabel(e:GetLabel())
	e4:SetValue(c12847502.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(c12847502.effectfilter)
	c:RegisterEffect(e5)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(12847502,2))
end
function c12847502.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsCode(e:GetLabel())
end
function c12847502.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c12847502.effectfilter2(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<2
end
function c12847502.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c12847502.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end