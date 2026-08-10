--歧路诗篇－无罪之门－
function c91300067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91300067,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetTarget(c91300067.target)
	e1:SetOperation(c91300067.activate)
	c:RegisterEffect(e1)
	--morra
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c91300067.morraop)
	c:RegisterEffect(e2)
	--
	if not c91300067.global_check then
		c91300067.global_check=true
		local _RockPaperScissors=Duel.RockPaperScissors
		function Duel.RockPaperScissors(...)
			for p in aux.TurnPlayers() do
				if Duel.GetFlagEffect(p,91300067)>0 and Duel.SelectYesNo(p,aux.Stringid(91300067,3)) then
					local te=Duel.IsPlayerAffectedByEffect(p,EFFECT_FLAG_EFFECT+91300067)
					te:Reset()
					Duel.Hint(HINT_CARD,0,91300067)
					return p
				end
			end
			return _RockPaperScissors(...)
		end
	end
	--
	if not CROSSROADS_MORRA then
		CROSSROADS_MORRA = true
		Crossroads_morra_effect_list={}
		Crossroads_morra_win_effect_list={}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c91300067.clear)
		Duel.RegisterEffect(ge0,0)
	end
end
function c91300067.clear(e,tp,eg,ep,ev,re,r,rp)
	Crossroads_morra_effect_list={}
	Crossroads_morra_win_effect_list={}
end
function c91300067.activate(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)--morra;91300063
	local p=Duel.RockPaperScissors()
	if e:IsActivated() then
		Crossroads_morra_win_effect_list[aux.Stringid(91300067,0)]=c91300067.win
		if p==tp then
			Crossroads_morra_effect_list[aux.Stringid(91300067,1)]=c91300067.lost
		else
			Crossroads_morra_effect_list[aux.Stringid(91300067,0)]=c91300067.win
		end
	end
	if c91300067.win(e,p,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(p,aux.Stringid(91300067,2)) then
		c91300067.win(e,p,eg,ep,ev,re,r,rp,1)
	end
	if c91300067.lost(e,1-p,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(1-p,aux.Stringid(91300067,2)) then
		c91300067.lost(e,1-p,eg,ep,ev,re,r,rp,1)
	end
end
function c91300067.tgfilter(c,p)
	return c:IsType(TYPE_QUICKPLAY) and c:CheckActivateEffect(true,true,false)~=nil and c:IsAbleToGrave() and c:IsFaceupEx() and not c:IsCode(91300067)
end
function c91300067.win(e,p,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c91300067.tgfilter,p,LOCATION_DECK,0,1,nil,p)
	else
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(p,c91300067.tgfilter,p,LOCATION_DECK,0,1,1,nil,p):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
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
function c91300067.lost(e,p,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c91300067.tgfilter,p,LOCATION_HAND+LOCATION_ONFIELD,0,1,aux.ExceptThisCard(e),p)
	else
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(p,c91300067.tgfilter,p,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e),p):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
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
function c91300067.morraop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then
		Duel.Hint(HINT_CARD,0,91300067)
		Duel.RegisterFlagEffect(tp,91300067,RESET_PHASE+PHASE_END,0,1)
	end
end
