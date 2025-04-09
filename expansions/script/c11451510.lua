--悠久之枷：断裁
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
	--reset
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_EVENT_PLAYER)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetOperation(cm.resop)
	e5:SetLabelObject(e1)
	--c:RegisterEffect(e5)
end
function cm.resop(e,tp,eg,ep,ev,re,r,rp)
	local re=e:GetLabelObject()
	re:SetOperation(cm.activate)
	re:SetCategory(CATEGORY_SPECIAL_SUMMON)
	re:SetLabel(0)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ev>1
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.mfilter(c)
	return c:IsSetCard(0x97d) and not c:IsType(TYPE_TOKEN)
end
function cm.xyzfilter(c,mg,tp)
	return c:IsXyzSummonable(mg) or c:IsLinkSummonable(mg) --and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		if e:IsHasType(EFFECT_TYPE_QUICK_O) then g:RemoveCard(e:GetHandler()) end
		for tc in aux.Next(g) do
			tc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_DARK,RACE_SPELLCASTER,6,0,0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
			e1:SetReset(RESET_EVENT+0x5fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_XYZ_LEVEL)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetValue(6)
			e2:SetReset(RESET_EVENT+0x5fe0000)
			tc:RegisterEffect(e2,true)
			cm[tc]={e1,e2}
		end
		local res=Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g,tp)
		for tc in aux.Next(g) do
			tc:AddMonsterAttribute(0,0,0,0,0,0)
			for _,se in pairs(cm[tc]) do
				se:Reset()
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
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
	local g=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	for tc in aux.Next(g) do
		tc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_DARK,RACE_SPELLCASTER,6,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x5fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetValue(6)
		e2:SetReset(RESET_EVENT+0x5fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetCountLimit(1)
		e3:SetLabelObject(tc)
		e3:SetOperation(cm.adjustop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(e4,tp)
		cm[tc]={e1,e2,e3,e4}
	end
	local xyzg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,g,tp)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		if xyz:IsLinkSummonable(g) then
			Duel.LinkSummon(tp,xyz,g)
		else
			Duel.XyzSummon(tp,xyz,g,1,#g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetCountLimit(1)
			e1:SetOperation(cm.handop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_SPSUMMON_NEGATED)
			Duel.RegisterEffect(e2,tp)
		end
	else
		for tc in aux.Next(g) do
			tc:AddMonsterAttribute(0,0,0,0,0,0)
			for _,se in pairs(cm[tc]) do
				se:Reset()
			end
		end
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:AddMonsterAttribute(0,0,0,0,0,0)
	if cm[tc] and aux.GetValueType(cm[tc])=="table" then
		for _,se in pairs(cm[tc]) do
			se:Reset()
		end
	end
	e:Reset()
end
function cm.handop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleHand(tp)
	if e:GetCode()==EVENT_SPSUMMON_SUCCESS and eg and eg:FilterCount(Card.IsSummonType,nil,SUMMON_TYPE_XYZ)>0 then
		for tc in aux.Next(eg:GetFirst():GetOverlayGroup()) do
			tc:CancelToGrave()
		end
	end
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return ev==e:GetLabel()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	re:SetOperation(cm.activate)
	re:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
		local b1=e:GetLabel()&(0x8-0x1)>0 and re:GetHandler():IsStatus(STATUS_CHAINING)
		local b2=e:GetLabel()&(0x40-0x8)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local b3=e:GetLabel()&(0x200-0x40)>0 and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToRemove()
		local b4=e:GetLabel()&(0x1000-0x200)>0
		local b5=e:GetLabel()&(0x8000-0x1000)>0 and Duel.IsPlayerCanDraw(tp,1)
		local b6=e:GetLabel()&(0x40000-0x8000)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
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
			Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
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
	--re:SetCategory(re:GetCategory()|CATEGORY_HANDES)
	if re:GetLabel()&0x49421~=0 then re:SetLabel(re:GetLabel()+0x8000) return end
	re:SetLabel(re:GetLabel()+0x8000)
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