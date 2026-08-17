--落渊寂星『梦幻泡影』
local cm,m=GetID()
function cm.initial_effect(c)
	-- 【卡片的发动】（空发动，纯粹的翻开动作）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- ①：把自己场上1只灵摆怪兽在自己的灵摆区域放置才能发动...
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	-- ②：自己墓地没有卡存在的场合这张卡破坏。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(cm.sdcon)
	c:RegisterEffect(e1)
	e2:SetLabelObject(e1)
end
function cm.cfilter(pc,c)
	return pc:IsType(TYPE_PENDULUM) and pc:IsFaceup() and Duel.IsExistingMatchingCard(function(tc) return tc:IsAbleToDeck() and (tc:IsType(TYPE_SPELL) or Duel.IsExistingMatchingCard(function(rc) return rc:IsFaceup() and (rc:GetType()&0x7)&tc:GetType()>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)) end,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil,c) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		local prop=e:GetProperty()
		e:SetProperty(prop|EFFECT_FLAG_IGNORE_IMMUNE)
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		e:SetProperty(prop)
		--Duel.SetTargetCard(tc)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	local c=e:GetHandler()
	--local pc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(function(tc) return tc:IsAbleToDeck() and Duel.IsExistingMatchingCard(function(rc) return rc:IsFaceup() and (rc:GetType()&0x7)&tc:GetType()>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then e:GetLabelObject():SetLabel(1) else e:GetLabelObject():SetLabel(0) end
	if #g>0 then Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,LOCATION_GRAVE) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=0
	local act=e:IsHasType(EFFECT_TYPE_ACTIVATE)
	--local pc=Duel.GetFirstTarget()
	--if not pc:IsRelateToEffect(e) then pc=nil end
	local g=Duel.GetMatchingGroup(function(tc) return tc:IsAbleToDeck() and Duel.IsExistingMatchingCard(function(rc) return rc:IsFaceup() and (rc:GetType()&0x7)&tc:GetType()>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,aux.ExceptThisCard(e)) end,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	while #g>0 do
		if count>0 then Duel.BreakEffect() end
		local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		GRAVILOID_COUNTER=count
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if #og>0 or #gg~=gg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE) then
			count=count+1
			if GRAVILOID_COUNTER then e:GetHandler():SetTurnCounter(count) GRAVILOID_COUNTER=nil end
		else
			GRAVILOID_COUNTER=nil
			break
		end
		if act then
			act=false
			e:GetLabelObject():SetLabel(0)
			Duel.AdjustAll()
		end
		g=Duel.GetMatchingGroup(function(tc) return tc:IsAbleToDeck() and Duel.IsExistingMatchingCard(function(rc) return rc:IsFaceup() and (rc:GetType()&0x7)&tc:GetType()>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,aux.ExceptThisCard(e)) end,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	end
	if act then
		e:GetLabelObject():SetLabel(0)
		Duel.AdjustAll()
	end
	if count > 0 then
		local dg = Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #dg >= count then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg = dg:Select(tp,count,count,nil)
			Duel.HintSelection(sg)
			local ntg=sg:Filter(aux.NegateAnyFilter,nil)
			if #ntg==#sg and Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0 then
				for tc in aux.Next(ntg) do
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e3)
					end
				end
			else
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end
function cm.sdcon(e)
	local tp=e:GetHandlerPlayer()
	local te=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)==0 and e:GetLabel()==0 --(not te or e:GetHandler()~=te:GetHandler() or not Duel.IsChainSolving())
end