--悠久之忆：归尘
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
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
end
function cm.setfilter(c)
	return c:GetType()&0x100004==0x100004 and c:IsSSetable(true)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_TOHAND) or re:IsHasCategory(CATEGORY_DRAW)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=1 end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>ft or e:IsHasType(EFFECT_TYPE_QUICK_O)) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(ev+1)
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--tc:RegisterEffect(e1)
	end
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return ev==e:GetLabel()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	re:SetOperation(cm.activate)
	re:SetCategory(CATEGORY_LEAVE_GRAVE)
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
		local b1=e:GetLabel()&0x1>0
		local b2=e:GetLabel()&0x2>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local b3=e:GetLabel()&0x4>0 and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToRemove()
		local b4=e:GetLabel()&0x8>0
		local b5=e:GetLabel()&0x10>0 and Duel.IsPlayerCanDraw(tp,1)
		local b6=e:GetLabel()&0x20>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		local b7=e:GetLabel()&0x40>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		local b8=e:GetLabel()&0x80>0
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
			e:SetLabel(e:GetLabel()&~0x1)
			Duel.NegateActivation(ev)
		elseif opval[op]==2 then
			e:SetLabel(e:GetLabel()&~0x2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		elseif opval[op]==3 then
			e:SetLabel(e:GetLabel()&~0x4)
			Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
		elseif opval[op]==4 then
			e:SetLabel(e:GetLabel()&~0x8)
			Duel.Damage(ep,2200,REASON_EFFECT)
		elseif opval[op]==5 then
			e:SetLabel(e:GetLabel()&~0x10)
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif opval[op]==6 then
			e:SetLabel(e:GetLabel()&~0x20)
			Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		elseif opval[op]==7 then
			e:SetLabel(e:GetLabel()&~0x40)
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
	re:SetCategory(re:GetCategory()|CATEGORY_DAMAGE)
	if re:GetLabel()&0xbf~=0 then re:SetLabel(re:GetLabel()|0x8) return end
	re:SetLabel(re:GetLabel()|0x8)
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