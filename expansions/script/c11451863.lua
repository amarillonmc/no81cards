--魔导飞行队强击指令
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCost(cm.hand)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetRange(LOCATION_HAND)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCost(cm.hand2)
	e3:SetTarget(function(e,c) return c~=e:GetHandler() end)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(m)
	--e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e3:SetTargetRange(1,0)
	e3:SetRange(LOCATION_HAND)
	--e3:SetCondition(cm.hand2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(cm.costcon)
	e4:SetCost(cm.costchk)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) then return end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc&0x1c>0 then
		rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_NEGATED)
		e2:SetLabel(ev)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_CHAIN)
		e2:SetOperation(cm.resetop)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ev==e:GetLabel() then rc:ResetFlagEffect(m) end
end
function cm.hand(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	local sc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if chk==0 then return sc and sc:IsFaceup() and Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,Card.IsSSetable,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.SSet(tp,tc,tp,false)
end
function cm.similarfilter(c,tp)
	return c:IsHasEffect(m) and c:IsSSetable()
end
function cm.hand2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local sc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if chk==0 then return sc and sc:IsFaceup() and e:GetHandler():IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 end
	local g=Duel.GetMatchingGroup(cm.similarfilter,tp,LOCATION_HAND,0,c,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=(g+c):Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,tc,tp,true)
	else
		Duel.SSet(tp,c,tp,true)
	end
end
function cm.costcon(e)
	cm[0]=false
	return true
end
function cm.costchk(e,te,tp)
	return true
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function cm.thfilter(c)
	return c:IsSetCard(0x6e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	if cm[0] then return end
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local prop1,prop2=te:GetProperty()
	local eset={Duel.IsPlayerAffectedByEffect(tp,m)}
	local case1=tc:IsType(TYPE_SPELL) and not tc:IsType(TYPE_QUICKPLAY)
	local case2=tc:IsType(TYPE_QUICKPLAY)
	local case3=tc:IsType(TYPE_TRAP)
	local sc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if sc and sc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and tc:IsLocation(LOCATION_HAND) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and not ((case2 and Duel.GetTurnPlayer()==1-tp) or case3) and ((tc:IsHasEffect(m) and tc==c and Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,1,c)) or (not tc:IsHasEffect(m) and c:IsSSetable())) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local cost=te:GetCost() or aux.TRUE
		local cost2=function(e,tp,eg,ep,ev,re,r,rp,chk)
						if chk==0 then return cost(e,tp,eg,ep,ev,re,r,rp,0) end
						cost(e,tp,eg,ep,ev,re,r,rp,1)
						e:SetCost(cost)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
						local tc=Duel.SelectMatchingCard(tp,Card.IsSSetable,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
						Duel.SSet(tp,tc,tp,false)
					end
		if not tc:IsHasEffect(m) then
			cost2=function(e,tp,eg,ep,ev,re,r,rp,chk)
						if chk==0 then return cost(e,tp,eg,ep,ev,re,r,rp,0) end
						cost(e,tp,eg,ep,ev,re,r,rp,1)
						e:SetCost(cost)
						local g=Duel.GetMatchingGroup(cm.similarfilter,tp,LOCATION_HAND,0,c,tp)
						if #g>0 then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
							local tc=(g+c):Select(tp,1,1,nil):GetFirst()
							Duel.SSet(tp,tc,tp,true)
						else
							Duel.SSet(tp,c,tp,true)
						end
					end
		end
		te:SetCost(cost2)
	end
	cm[0]=true
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local sc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if sc and sc:IsFaceup() and c:IsStatus(STATUS_ACT_FROM_HAND) and (Duel.GetTurnPlayer()==1-tp or (Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(m,0)))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,Card.IsSSetable,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		Duel.SSet(tp,tc,tp,false)
	end
end
function cm.acfilter(c)
	return c:GetFlagEffect(m)>0 and c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.acfilter,tp,0,0x1c,nil)
	if chk==0 then return #g>0 end
	Duel.HintSelection(g)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.acfilter,tp,0,0x1c,nil)
	for tc in aux.Next(g) do
		local e3=Effect.CreateEffect(tc)
		e3:SetDescription(aux.Stringid(m,1))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e3:SetRange(0x1c)
		e3:SetCode(EVENT_CUSTOM+m)
		e3:SetCountLimit(1)
		e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e3:SetTarget(cm.thtg2)
		e3:SetOperation(cm.thop2)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3,true)
	end
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetCondition(function() return Duel.GetCurrentChain()==1 end)
	e6:SetOperation(function(e) Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,0,0,0,0) end)
	e6:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e6,tp)
	local e7=e6:Clone()
	e7:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e7,tp)
end
function cm.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function cm.distance2(ac,bc,tp)
	local ax,ay=cm.xylabel(ac,tp)
	local bx,by=cm.xylabel(bc,tp)
	return ((by-ay)*(by-ay)+(ax-bx)*(ax-bx))*1000
end
function cm.gsfilter(c,tc)
	return math.abs(c:GetSequence()-tc:GetSequence())==1
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if c:IsOnField() then
		local ng=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		local ag=ng:GetMinGroup(cm.distance2,c,tp):Filter(Card.IsCanBeEffectTarget,nil,e)
		if #ag>0 then Duel.SetTargetCard(ag) end
	else
		local ng=Duel.GetMatchingGroup(cm.gsfilter,tp,LOCATION_GRAVE,0,nil,c)
		local ag=ng:Filter(Card.IsCanBeEffectTarget,nil,e)
		if #ag>0 then Duel.SetTargetCard(ag) end
	end
end
function Group.ForEach(group,func,...)
	if aux.GetValueType(group)=="Group" and group:GetCount()>0 then
		local d_group=group:Clone()
		for tc in aux.Next(d_group) do
			func(tc,...)
		end
	end
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	g:KeepAlive()
	g:ForEach(Card.RegisterFlagEffect,m-10,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,10))
	for tc in aux.Next(g) do
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_SINGLE)
		ge2:SetCode(EFFECT_IMMUNE_EFFECT)
		ge2:SetRange(0x1c)
		ge2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge2:SetLabelObject(g)
		ge2:SetValue(cm.chkval)
		ge2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(ge2,true)
	end
end
function cm.chkval(e,te)
	if e:GetHandler():GetFlagEffect(m-10)>0 and te and te:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and te:IsHasType(EFFECT_TYPE_ACTIONS) then
		local g=e:GetLabelObject()
		g:ForEach(Card.ResetFlagEffect,m-10)
		if Duel.GetFlagEffect(tp,0xffff+m)==0 then
			Duel.RegisterFlagEffect(tp,0xffff+m,RESET_CHAIN,0,1)
			if SetCardData then
				Duel.Hint(24,0,aux.Stringid(m,2))
			else
				Debug.Message("「强击」任务进度更新！")
			end
		end
		local tc=te:GetHandler()
		local e3=Effect.CreateEffect(tc)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetCondition(function() return not pnfl_adjusting end)
		e3:SetOperation(cm.tdop)
		Duel.RegisterEffect(e3,te:GetHandlerPlayer())
	end
	return false
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	pnfl_adjusting=true
	Duel.BreakEffect()
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence),REASON_EFFECT)
	e:Reset()
	pnfl_adjusting=false
end