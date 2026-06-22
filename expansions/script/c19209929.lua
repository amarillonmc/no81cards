--引诱饥献 拉拉拉坡可可
function c19209929.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,19209929)
	e1:SetTarget(c19209929.thtg)
	e1:SetOperation(c19209929.thop)
	c:RegisterEffect(e1)
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209929,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	--e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	--e2:SetCountLimit(1,19209929)
	e2:SetCondition(c19209929.cfcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c19209929.cftg)
	e2:SetOperation(c19209929.cfop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19209929,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+19209929)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,19209929+1)
	e3:SetCondition(c19209929.tgcon)
	e3:SetTarget(c19209929.tgtg)
	e3:SetOperation(c19209929.tgop)
	c:RegisterEffect(e3)
	if not c19209929.global_check then
		c19209929.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_RELEASE)
		ge2:SetCondition(c19209929.regcon)
		ge2:SetOperation(c19209929.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c19209929.thfilter(c,chk)
	return c:IsSetCard(0xb54) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))-- and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c19209929.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209929.thfilter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19209929.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209929.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	--if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(19209929,2)) then return end
end
function c19209929.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and r&REASON_EFFECT~=0 and rp==tp and re and re:GetHandler():IsSetCard(0xb54)
end
function c19209929.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(1-tp)>0 end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetTargetCard(g)
end
function c19209929.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		local p=1-tp
		local sg=g:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,p,false,false)
		if #sg>0 and Duel.GetMZoneCount(p)>0 and Duel.SelectYesNo(tp,aux.Stringid(19209929,3)) then
			local ft=Duel.IsPlayerAffectedByEffect(p,59822133) and 1 or Duel.GetMZoneCount(p)
			if #sg>ft then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
				sg=sg:Select(p,ft,ft,nil)
			end
			local ct=Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEUP)
			if ct==0 then Duel.ShuffleHand(1-tp) return end
			local og=Duel.GetOperatedGroup()
			for tc in aux.Next(og) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2,true)
			end
			if ct>=2 then
				Duel.BreakEffect()
				Duel.Draw(p,2,REASON_EFFECT)
			end
		end
		Duel.ShuffleHand(1-tp)
	end
end
function c19209929.chkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c19209929.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(c19209929.chkfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c19209929.chkfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c19209929.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+19209929,re,r,rp,ep,e:GetLabel())
end
function c19209929.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return (ev==tp or ev==PLAYER_ALL) and not eg:IsContains(e:GetHandler())
end
function c19209929.tgfilter(c,e,tp)
	return c:IsSetCard(0xb54) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c19209929.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209929.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c19209929.tgfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c19209929.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c19209929.tgfilter,tp,LOCATION_REMOVED,0,nil)
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=g:Select(tp,1,1,nil)
	end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
end
