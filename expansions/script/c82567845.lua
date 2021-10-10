--方舟骑士·除魅 莫斯提马
function c82567845.initial_effect(c)
	c:EnableReviveLimit()
	--fusion
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(c82567845.fusionfilter1),aux.FilterBoolFunction(c82567845.fusionfilter2),1,true,true)
	--add race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(RACE_FIEND)
	c:RegisterEffect(e1)
	--skip BP
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetDescription(aux.Stringid(82567845,0))
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,82567845)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c82567845.skipcon)
	e3:SetCost(c82567845.skipcost)
	e3:SetOperation(c82567845.skipop)
	c:RegisterEffect(e3)
	--AddCounter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567845,1))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,82567845)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c82567845.ctcon)
	e4:SetOperation(c82567845.ctop)
	c:RegisterEffect(e4)
	--ATK
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567845,2))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetTarget(c82567845.target)
	e5:SetOperation(c82567845.operation)
	c:RegisterEffect(e5)
end
function c82567845.fusionfilter1(c)
	return (c:IsFusionAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY)) or c:IsRace(RACE_FAIRY) or c:IsFusionAttribute(ATTRIBUTE_LIGHT)  
end
function c82567845.fusionfilter2(c)
	return (c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)) or c:IsFusionAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_FIEND)
end
function c82567845.ovfilter(c)
	return c:IsCode(82567844) 
end
function c82567845.skipcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetTurnPlayer()==tp 
end
function c82567845.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,3,REASON_COST)
end
function c82567845.skipop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCode(EFFECT_SKIP_DP)
	if Duel.GetTurnPlayer()==1-tp then
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetCondition(c82567845.turncon)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e2,tp)
   local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCode(EFFECT_SKIP_M1)
	if Duel.GetTurnPlayer()==1-tp then
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetCondition(c82567845.turncon)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e2,tp)
end
function c82567845.turncon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c82567845.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetAttackAnnouncedCount()==0
end
function c82567845.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x5825,2)
end
function c82567845.filter(c,g)
	return c:IsFaceup()
end 
function c82567845.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82567845.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567845.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) and
	 (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c82567845.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82567845.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c82567845.dwcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==2
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c82567845.dwtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c82567845.dwactivate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e1,tp)
end