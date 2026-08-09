--歧路诗篇－虫食泥沼－
function c91300075.initial_effect(c)
	--public
	local e0=Effect.CreateEffect(c)
	e0:SetHintTiming(TIMING_DRAW_PHASE)
	e0:SetDescription(aux.Stringid(91300075,0))
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c91300075.accon)
	--e0:SetCost(c91300075.accost)
	e0:SetOperation(c91300075.acop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91300075,1))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c91300075.target)
	e1:SetOperation(c91300075.activate)
	c:RegisterEffect(e1)
	--act qp in hand
	--[[local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91300075,4))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(c91300075.excost)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e2)]]
	--Activate from grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_REMOVED)
	--e2:SetCondition()
	e2:SetOperation(c91300075.gaop)
	c:RegisterEffect(e2)
	--sign
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(91300075)
	e3:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	--
	if not CROSSROADS_ENTITY then
		CROSSROADS_ENTITY = true
		Crossroads_card_list={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetOperation(c91300075.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c91300075.regop(e,tp,eg,ep,ev,re,r,rp)
	for _,code in pairs({91300063,91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
		local tc=Duel.CreateToken(0,code)
		Crossroads_card_list[code]=tc
	end
end
function c91300075.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DRAW and not e:GetHandler():IsPublic()
end
function c91300075.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(91300075,2)) then
		Duel.ConfirmCards(1-tp,c)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_PUBLIC)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e0)
		local d=Duel.TossDice(tp,1)
		if d==1 or d==3 or d==6 then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(91300075,4))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		elseif d==2 or d==4 or d==5 then
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c91300075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,3)
end
function c91300075.activate(e,tp,eg,ep,ev,re,r,rp)
	local d1,d2,d3=Duel.TossDice(tp,3)
	local v=(d1+d2+d3)
	if v<=9 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,2,2,nil)
		if #rg==2 then
			Duel.HintSelection(rg)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
	if v>=18 then
		local ph=Duel.GetCurrentPhase()
		if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+ph)
		Duel.RegisterEffect(e1,tp)
	end
	if v>=9 then
		local codes={}
		for _,code in pairs({91300063,91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
			local tc=Crossroads_card_list[code]
			if tc:CheckActivateEffect(false,true,false)~=nil then--code~=e:GetHandler():GetCode() and 
				table.insert(codes,code)
			end
		end
		if #codes==0 then return end
		table.sort(codes)
		--c:IsCode(codes[1])
		local afilter={codes[1],OPCODE_ISCODE}
		if #codes>1 then
			--or ... or c:IsCode(codes[i])
			for i=2,#codes do
				table.insert(afilter,codes[i])
				table.insert(afilter,OPCODE_ISCODE)
				table.insert(afilter,OPCODE_OR)
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
		local tc=Crossroads_card_list[ac]
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
		Duel.ClearTargetCard()
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		e:SetProperty(0)--Original Property
	end
end
function c91300075.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c91300075.qfilter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:CheckActivateEffect(true,true,false)~=nil and not c:IsHasEffect(91300075)
end
function c91300075.gaop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c91300075.qfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	for tc in aux.Next(g) do
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(91300075)
		e0:SetRange(LOCATION_GRAVE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0,true)
		local te=tc:CheckActivateEffect(true,true,false)
		local ce=te:Clone()
		ce:SetRange(LOCATION_GRAVE)
		ce:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(ce)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		--e1:SetLabelObject(ce)
		e1:SetTargetRange(1,1)
		e1:SetTarget(
			function (e,te,tp)
				e:SetLabelObject(te)
				return te==ce and Duel.IsExistingMatchingCard(c91300075.tdfilter,0,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
			end)--c91300075.extg
		e1:SetOperation(c91300075.exop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c91300075.tdfilter(c)
	return c:IsHasEffect(91300075) and c:IsAbleToDeck()
end
function c91300075.extg(e,te,tp)
	e:SetLabelObject(te)
	return te==e:GetLabelObject() and Duel.IsExistingMatchingCard(c91300075.tdfilter,0,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)--te:GetHandler()==e:GetHandler()
end
function c91300075.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c91300075.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		g=g:Select(tp,1,1,nil)
	end
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	--
	local te=e:GetLabelObject()
	Duel.MoveToField(te:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	te:GetHandler():CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(te:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(te,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(c91300075.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	e:Reset()
end
function c91300075.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
