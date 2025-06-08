--悠久之径：逶迤
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	--addition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.chcon)
	e4:SetOperation(cm.chop)
	c:RegisterEffect(e4)
	if not CARD_TARGET_CHECK then
		CARD_TARGET_CHECK={}
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_ACTIVATE_COST)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(1,1)
		e5:SetTarget(cm.actarget2)
		e5:SetOperation(cm.costop2)
		Duel.RegisterEffect(e5,0)
	end
end
local _SetProperty=Effect.SetProperty
function cm.actarget2(e,te,tp)
	if not CARD_TARGET_CHECK[te] then e:SetLabelObject(te) end
	return not CARD_TARGET_CHECK[te]
end
function cm.extfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsStatus(STATUS_EFFECT_ENABLED)) and (c:IsHasEffect(11451779) or c:IsHasEffect(11451780) or c:IsHasEffect(11451781) or c:IsHasEffect(11451782))
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if CARD_TARGET_CHECK[te] then return end
	function Effect.SetProperty(se,prop1,prop2)
		if prop1&EFFECT_FLAG_CARD_TARGET>0 then CARD_TARGET_CHECK[se]=true end
		return _SetProperty(se,prop1,prop2)
	end
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetOperation(cm.adjustop)
	Duel.RegisterEffect(e6,0)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then CARD_TARGET_CHECK[re]=nil end
	Effect.SetProperty=_SetProperty
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	return CARD_TARGET_CHECK[re]
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,2,2,REASON_EFFECT+REASON_DISCARD)
	end
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return ev==e:GetLabel()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	re:SetOperation(cm.activate)
	re:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	re:SetLabel(0)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) and re:GetHandler():IsSetCard(0x97d) and re:GetHandler():GetType()&0x100004==0x100004 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.addition(e,tp,eg,ep,ev,re,r,rp)
	while 1==1 do
		local off=1
		local ops={} 
		local opval={}
		local b1=e:GetLabel()&(0x8-0x1)>0 and e:GetCode()==EVENT_CHAINING and Duel.IsChainNegatable(ev)
		local b2=e:GetLabel()&(0x40-0x8)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local b3=e:GetLabel()&(0x200-0x40)>0 and e:GetCode()==EVENT_CHAINING and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToRemove()
		local b4=e:GetLabel()&(0x1000-0x200)>0 and e:GetCode()==EVENT_CHAINING
		local b5=e:GetLabel()&(0x8000-0x1000)>0 and Duel.IsPlayerCanDraw(tp,1)
		local b6=e:GetLabel()&(0x40000-0x8000)>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local b7=e:GetLabel()&(0x200000-0x40000)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		local b8=e:GetLabel()&(0x1000000-0x200000)>0
		if b1 then
			ops[off]=aux.Stringid(11451505,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(11451506,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(11451507,1)
			opval[off-1]=3
			off=off+1
		end
		if b4 then
			ops[off]=aux.Stringid(11451508,1)
			opval[off-1]=4
			off=off+1
		end
		if b5 then
			ops[off]=aux.Stringid(11451509,1)
			opval[off-1]=5
			off=off+1
		end
		if b6 then
			ops[off]=aux.Stringid(11451510,1)
			opval[off-1]=6
			off=off+1
		end
		if b7 then
			ops[off]=aux.Stringid(9310055,1)
			opval[off-1]=7
			off=off+1
		end
		if b8 then
			cm.regsop(e,tp,eg,ep,ev,re,r,rp)
		end
		if off==1 then break end
		ops[off]=aux.Stringid(11451505,2)
		opval[off-1]=8
		--mobile adaption
		local ops2=ops
		local op=-1
		if off<=5 then
			op=Duel.SelectOption(tp,table.unpack(ops))
		else
			local page=0
			while op==-1 do
				if page==0 then
					ops2={table.unpack(ops,1,4)}
					table.insert(ops2,aux.Stringid(11451505,4))
					op=Duel.SelectOption(tp,table.unpack(ops2))
					if op==4 then op=-1 page=1 end
				else
					ops2={table.unpack(ops,5,off)}
					table.insert(ops2,1,aux.Stringid(11451505,3))
					op=Duel.SelectOption(tp,table.unpack(ops2))+3
					if op==3 then op=-1 page=0 end
				end
			end
		end
		if opval[op]==1 then
			Duel.BreakEffect()
			e:SetLabel(e:GetLabel()-0x1)
			Duel.NegateActivation(ev)
		elseif opval[op]==2 then
			Duel.BreakEffect()
			e:SetLabel(e:GetLabel()-0x8)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		elseif opval[op]==3 then
			Duel.BreakEffect()
			e:SetLabel(e:GetLabel()-0x40)
			Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
		elseif opval[op]==4 then
			Duel.BreakEffect()
			e:SetLabel(e:GetLabel()-0x200)
			Duel.Damage(ep,2200,REASON_EFFECT)
		elseif opval[op]==5 then
			Duel.BreakEffect()
			e:SetLabel(e:GetLabel()-0x1000)
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif opval[op]==6 then
			Duel.BreakEffect()
			e:SetLabel(e:GetLabel()-0x8000)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(11451031,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1,true)
		elseif opval[op]==7 then
			Duel.BreakEffect()
			e:SetLabel(e:GetLabel()-0x40000)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		elseif opval[op]==8 then break end
	end
end
function cm.regsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if Duel.GetFlagEffect(tp,11451928)>0 then return end
	--Duel.RegisterFlagEffect(tp,11451928,RESET_PHASE+PHASE_END,0,1)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetDescription(aux.Stringid(11451927,2))
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCondition(function() return Duel.GetTurnPlayer()==tp end)
	e1:SetTargetRange(LOCATION_HAND,0)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	Duel.RegisterEffect(e2,1-tp)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(cm.disscon)
	e3:SetOperation(cm.dissop)
	--e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(function() return Duel.GetTurnPlayer()==tp end)
	e4:SetTarget(cm.indtg)
	e4:SetValue(function(e) e:SetLabel(1) return 1 end)
	--e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function cm.indtg(e,c)
	local tc=e:GetHandler()
	return c:IsFaceup() and e:GetLabel()==0
end
function cm.disscon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and Duel.GetTurnPlayer()==tp
end
function cm.dissop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
	e:Reset()
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	--re:SetCategory(re:GetCategory()|CATEGORY_REMOVE)
	if re:GetLabel()&0x49421~=0 then re:SetLabel(re:GetLabel()+0x40) return end
	re:SetLabel(re:GetLabel()+0x40)
	local op=re:GetOperation()
	local repop=function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		cm.addition(e,tp,eg,ep,ev,re,r,rp)
	end
	if re:GetHandler():GetOriginalCode()==11451510 or (aux.GetValueType(re:GetLabelObject())=="Effect" and re:GetLabelObject():GetHandler():GetOriginalCode()==11451510) then
		repop=function(e,tp,eg,ep,ev,re,r,rp)
			cm.addition(e,tp,eg,ep,ev,re,r,rp)
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
	re:SetOperation(repop)
end