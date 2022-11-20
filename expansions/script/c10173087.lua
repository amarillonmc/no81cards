--猜拳游戏
function c10173087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10173087.condition)
	c:RegisterEffect(e1)  
	--rock paper
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c10173087.negcon)
	e2:SetOperation(c10173087.negop)
	c:RegisterEffect(e2) 
end
function c10173087.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c10173087.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function c10173087.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local tf=false
	Duel.Hint(HINT_CARD,0,10173087)
	repeat
	  local res=Duel.RockPaperScissors()
	  if res==rp then break end
	  local rlp=Duel.GetLP(rp)
	  local b1=Duel.IsChainDisablable(ev)
	  local b2=rlp>500
	  local b3=rlp>1000
	  local off=1
	  local ops={}
	  local opval={}
	  if b1 then
		 ops[off]=aux.Stringid(10173087,0)
		 opval[off-1]=1
		 off=off+1
	  end
	  if b2 then
		 ops[off]=aux.Stringid(10173087,1)
		 opval[off-1]=2
		 off=off+1
	  end
	  if b3 then
		 ops[off]=aux.Stringid(10173087,2)
		 opval[off-1]=3
		 off=off+1
	  end
	  ops[off]=aux.Stringid(10173087,3)
	  opval[off-1]=4
	  off=off+1
	  local op=Duel.SelectOption(rp,table.unpack(ops))
	  local sel=opval[op]
	  if sel==1 then
		 Duel.NegateEffect(ev)
		 break 
	  elseif sel==2 then
		 Duel.SetLP(rp,rlp-500)
	  elseif sel==3 then
		 Duel.SetLP(rp,rlp-1000)
		 break 
	  else
		 Duel.SetLP(rp,0)
		 break  
	  end
	until tf
end