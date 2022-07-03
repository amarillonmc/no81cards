--大群之爪 裂礁者
function c79078006.initial_effect(c)
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(79078006,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,79078006)
	e1:SetCondition(c79078006.condition2)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c79078006.target2)
	e1:SetOperation(c79078006.operation2)
	c:RegisterEffect(e1)
	c79078006.remove_effect=e1
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,79078006+1500)
	e2:SetCondition(c79078006.condition)
	e2:SetTarget(c79078006.target)
	e2:SetOperation(c79078006.operation)
	c:RegisterEffect(e2)
end
c79078006.named_with_Massacre=true
function c79078006.condition2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:GetControler()==tp and a.named_with_Massacre and a:IsRelateToBattle())
		or (d:GetControler()==tp and d.named_with_Massacre and d:IsRelateToBattle()))
end
function c79078006.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,79078006)==0 end  
	Duel.RegisterFlagEffect(tp,79078006,RESET_CHAIN,0,1) 
end 
function c79078006.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	if a:GetControler()==tp then
		e1:SetValue(d:GetAttack())
		a:RegisterEffect(e1)
	else
		e1:SetValue(a:GetAttack())
		d:RegisterEffect(e1)
	end
end


function c79078006.condition(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return  re:IsActiveType(TYPE_MONSTER) and race&RACE_FISH>0
end
function c79078006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetFlagEffect(tp,79078006)==0 end  
	Duel.RegisterFlagEffect(tp,79078006,RESET_CHAIN,0,1) 
	local dg=Group.CreateGroup()
	for i=1,ev do
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	dg:AddCard(tc)
	end
	if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(79078006,1)) then 
	local lg=dg:Select(tp,1,1,nil)
	local lc=lg:GetFirst()
	while lc do
	lc:RegisterFlagEffect(79078006,RESET_CHAIN,0,1)
	lc=lg:GetNext()
	end
	for i=1,ev do
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	local p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	if tc:GetFlagEffect(79078006)~=0 and Duel.NegateActivation(i) and tc:IsRelateToEffect(te) then 
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
	end
	end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function c79078006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)  
	end 
end

