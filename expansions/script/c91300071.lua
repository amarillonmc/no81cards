--歧路诗篇－隐秘坑道－
function c91300071.initial_effect(c)
	--public
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c91300071.accon)
	--e0:SetCost(c91300071.accost)
	e0:SetOperation(c91300071.acop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91300071,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c91300071.target)
	e1:SetOperation(c91300071.activate)
	c:RegisterEffect(e1)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91300071,4))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c91300071.excost)
	e2:SetTarget(function (e,c) return e:GetHandler()~=c end)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e2)
	--
	if not CROSSROADS_COIN then
		CROSSROADS_COIN = true
		Crossroads_coin_effect_list={}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c91300071.clear)
		Duel.RegisterEffect(ge0,0)
	end
end
function c91300071.clear(e,tp,eg,ep,ev,re,r,rp)
	Crossroads_coin_effect_list={}
end
function c91300071.accon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and not e:GetHandler():IsPublic()
end
function c91300071.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(91300071,2)) then
		Duel.ConfirmCards(1-tp,c)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_PUBLIC)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e0)
		if Duel.TossCoin(tp,1)==1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
			e1:SetCondition(c91300071.excondition)
			e1:SetDescription(aux.Stringid(91300071,4))
			e1:SetLabel(ev)
			e1:SetReset(RESET_CHAIN)
			c:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetLabel(c:GetFieldID())
			e1:SetValue(c91300071.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c91300071.excondition(e)
	return Duel.GetCurrentChain()==e:GetLabel()
end
function c91300071.aclimit(e,re,tp)
	if e:GetLabel()~=e:GetHandler():GetFieldID() then e:Reset() return false end
	return re:GetHandler()==e:GetOwner() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c91300071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c91300071.activate(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)--coin;91300063
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local opt=Duel.AnnounceCoin(tp)
	local coin=Duel.TossCoin(tp,1)
	if opt~=coin then
		c91300071.correct(e,tp,eg,ep,ev,re,r,rp,1)
		if e:IsActivated() then
			Crossroads_coin_effect_list[aux.Stringid(91300071,1)]=c91300071.wrong
		end
	else
		c91300071.wrong(e,tp,eg,ep,ev,re,r,rp,1)
		if e:IsActivated() then
			Crossroads_coin_effect_list[aux.Stringid(91300071,0)]=c91300071.correct
		end
	end
end
function c91300071.chkfilter(c,p)
	return c:IsSetCard(0x855) and c:GetActivateEffect():IsActivatable(p,true,true) and not c:IsPublic()
end
function c91300071.correct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCountLimit(1)
		e1:SetCondition(c91300071.discon)
		e1:SetOperation(c91300071.disop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		if Duel.IsExistingMatchingCard(c91300071.chkfilter,tp,LOCATION_HAND,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(91300071,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local tc=Duel.SelectMatchingCard(tp,c91300071.chkfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
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
end
function c91300071.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c91300071.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,91300071)
	Duel.NegateEffect(ev,true)
end
function c91300071.wrong(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={}
	if CROSSROADS_MORRA then
		for des,f in pairs(Crossroads_morra_effect_list) do
			local res=f(e,tp,eg,ep,ev,re,r,rp,0)
			if res then
				for _,v in pairs(t) do
					if v==des then res=false end
				end
			end
			if res then table.insert(t,des) end
		end
	end
	if chk==0 then
		return #t>0
	else
		if #t>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVEEFFECT)
			local sel=Duel.SelectOption(tp,table.unpack(t))
			local des=t[sel+1]
			local f=Crossroads_morra_effect_list[des]
			f(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c91300071.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPublic() and c:IsAbleToGrave() end
	Duel.SendtoGrave(c,REASON_EFFECT)
end
