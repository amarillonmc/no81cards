--百千抉择的王女 塞特亚・基鲁特利
function c67201129.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201129,3))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c67201129.thcost)
	e1:SetTarget(c67201129.thtg)
	e1:SetOperation(c67201129.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	c:RegisterEffect(e2) 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201129,0))
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CUSTOM+67201129)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,67201129)
	e3:SetCondition(c67201129.opcon)
	e3:SetCost(c67201129.opcost)
	e3:SetOperation(c67201129.opop)
	c:RegisterEffect(e3) 
	if not c67201129.global_check then
		c67201129.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c67201129.regcon)
		ge1:SetOperation(c67201129.regop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c67201129.regfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c67201129.regcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==0 then return false end
	local v=0
	if eg:IsExists(c67201129.regfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c67201129.regfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c67201129.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+67201129,re,r,rp,ep,e:GetLabel())
end
--
function c67201129.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c67201129.thfilter(c)
	return c:IsCode(67201128) and c:IsAbleToHand()
end
function c67201129.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c67201129.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	--Duel.ConfirmCards(1-tp,tc)
	if not tc:IsSetCard(0x3670) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
--
function c67201129.opcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==1-tp or ev==PLAYER_ALL
end
function c67201129.drfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x3670)
end
function c67201129.opcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c67201129.drfilter,tp,LOCATION_HAND,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67201129.drfilter,tp,LOCATION_HAND,0,1,1,c,tp)+c
	Duel.SendtoGrave(g,REASON_COST)
end
function c67201129.ddfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function c67201129.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(c67201129.ddfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 end
end
function c67201129.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c67201129.ddfilter,nil,tp)
	local b1=true
	local b2=g:GetCount()>0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201129,1),aux.Stringid(67201129,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201129,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201129,2))+1
	else return end
	if op==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		--e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(c67201129.thcon2)
		e1:SetOperation(c67201129.thop2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
--

function c67201129.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_DRAW) 
end
function c67201129.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,67201129)
	Duel.Damage(1-tp,100,REASON_EFFECT)
end

