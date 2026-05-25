--合辛的必胜投资
function c17337715.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17337715)
	e1:SetCost(c17337715.cost)
	e1:SetTarget(c17337715.target)
	e1:SetOperation(c17337715.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17337715,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c17337715.thcon)
	e2:SetTarget(c17337715.thtg)
	e2:SetOperation(c17337715.thop)
	c:RegisterEffect(e2)
	if not c17337715.global_check then
		c17337715.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(c17337715.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c17337715.regop(e,tp,eg,ep,ev,re,r,rp)
	if r==REASON_EFFECT and not re:GetHandler():IsCode(17337715) then
		Duel.RegisterFlagEffect(ep,17337715,RESET_PHASE+PHASE_END,0,1)
	end
end
function c17337715.cfilter(c)
	return c:IsSetCard(0x3f51) and not c:IsPublic()
end
function c17337715.gcheck(g,tp)
	return Duel.GetDecktopGroup(tp,#g):IsExists(Card.IsAbleToHand,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=#g
end
function c17337715.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17337715.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c17337715.cfilter,tp,LOCATION_HAND,0,nil)
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		g=g:SelectSubGroup(tp,c17337715.gcheck,false,1,#g,tp)
	end
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(#g)
	Duel.ShuffleHand(tp)
end
function c17337715.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c17337715.cfilter,tp,LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return Duel.GetDecktopGroup(tp,ct):IsExists(Card.IsAbleToHand,1,nil) and e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17337715.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if #g>0 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc:IsAbleToHand() then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(sc,REASON_RULE)
		end
	end
	if #g>1 then
		Duel.SortDecktop(tp,tp,#g-1)
		--[[for i=1,#g-1 do
			local dg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
		end]]
	end
end
function c17337715.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c17337715.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and Duel.GetFlagEffect(tp,17337715)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c17337715.thlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c17337715.thlimit(e,c,tp,re)
	return re and not re:GetHandler():IsCode(17337715)
end
function c17337715.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and e:GetHandler():IsAbleToHand() end
	aux.GiveUpNormalDraw(e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c17337715.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,c)
	end
end
