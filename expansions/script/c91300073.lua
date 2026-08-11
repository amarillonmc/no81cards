--歧路诗篇－寒霜峡谷－
function c91300073.initial_effect(c)
	--public
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c91300073.accon)
	--e0:SetCost(c91300073.accost)
	e0:SetOperation(c91300073.acop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91300073,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c91300073.target)
	e1:SetOperation(c91300073.activate)
	c:RegisterEffect(e1)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91300073,4))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c91300073.excost)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e2)
	--
	if not CROSSROADS_MORRA then
		CROSSROADS_MORRA = true
		Crossroads_morra_effect_list={}
		Crossroads_morra_win_effect_list={}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c91300073.clear)
		Duel.RegisterEffect(ge0,0)
	end
end
function c91300073.clear(e,tp,eg,ep,ev,re,r,rp)
	Crossroads_morra_effect_list={}
	Crossroads_morra_win_effect_list={}
end
function c91300073.accon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and not e:GetHandler():IsPublic()
end
function c91300073.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(91300073,2)) then
		Duel.ConfirmCards(1-tp,c)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_PUBLIC)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e0)
		local p=Duel.RockPaperScissors()
		if c:IsDiscardable(REASON_EFFECT) and c91300073.target(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(p,aux.Stringid(91300073,3)) then
			Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
			c91300073.activate(e,p,eg,ep,ev,re,r,rp)
			--[[local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_CUSTOM+91300073)
			e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
			e1:SetRange(LOCATION_HAND)
			--e1:SetCondition(function (e,tp,eg,ep,ev,re,r,rp) return ep==tp end)
			e1:SetOperation(c91300073.activate)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+91300073,e,0,p,p,0)]]
		end
	end
end
function c91300073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c91300073.win(e,tp,eg,ep,ev,re,r,rp,0) or c91300073.lost(e,tp,eg,ep,ev,re,r,rp,0) end
end
function c91300073.activate(e,tp,eg,ep,ev,re,r,rp)
	Dead_Town_99_Check=true--morra;91300063
	local p=Duel.RockPaperScissors()
	if e:IsActivated() then
		Crossroads_morra_win_effect_list[aux.Stringid(91300073,0)]=c91300073.win
		if p==tp then
			Crossroads_morra_effect_list[aux.Stringid(91300073,1)]=c91300073.lost
		else
			Crossroads_morra_effect_list[aux.Stringid(91300073,0)]=c91300073.win
		end
	end
	if c91300073.win(e,p,eg,ep,ev,re,r,rp,0) then
		c91300073.win(e,p,eg,ep,ev,re,r,rp,1)
	end
	if c91300073.lost(e,1-p,eg,ep,ev,re,r,rp,0) then
		c91300073.lost(e,1-p,eg,ep,ev,re,r,rp,1)
	end
end
function c91300073.tgfilter(c,p)
	return (c:IsSetCard(0x855) and c:IsLocation(LOCATION_DECK) and c:CheckActivateEffect(true,true,false)~=nil and not c:IsCode(91300073) or c:IsControler(1-p)) and c:IsAbleToGrave()
end
function c91300073.win(e,p,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c91300073.tgfilter,p,LOCATION_DECK,LOCATION_HAND+LOCATION_ONFIELD,1,nil,p)
	else
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(p,c91300073.tgfilter,p,LOCATION_DECK,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil,p):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		if Duel.SendtoGrave(tc,REASON_RULE)~=0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsPreviousControler(p) then
			Duel.BreakEffect()
			local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
			Duel.ClearTargetCard()
			e:SetProperty(te:GetProperty())
			local tg=te:GetTarget()
			if tg then tg(e,p,eg,ep,ev,re,r,rp,1) end
			local op=te:GetOperation()
			if op then op(e,p,eg,ep,ev,re,r,rp) end
			e:SetProperty(0)--Original Property
		end
	end
end
function c91300073.lost(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={}
	if CROSSROADS_COIN then
		for des,f in pairs(Crossroads_coin_effect_list) do
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
			local f=Crossroads_coin_effect_list[des]
			f(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c91300073.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
