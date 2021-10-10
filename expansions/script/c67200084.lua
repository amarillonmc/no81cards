--创刻-椎名沙夜音
function c67200084.initial_effect(c)
	--spsummon or draw or SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200084,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200084)
	e1:SetCondition(c67200084.descon)
	e1:SetCost(c67200084.descost)
	e1:SetTarget(c67200084.destg)
	e1:SetOperation(c67200084.desop)
	c:RegisterEffect(e1)	
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200084,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,67200085)
	e2:SetTarget(c67200084.thtg)
	e2:SetOperation(c67200084.thop)
	c:RegisterEffect(e2) 
end
function c67200084.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c67200084.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c67200084.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c67200084.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x673)
end
function c67200084.desfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsSummonLocation(LOCATION_EXTRA) and c:IsLocation(LOCATION_MZONE)
end
function c67200084.spfilter(c,e,tp)
	return c:IsSetCard(0x673) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200084.filter(c)
	return c:IsSetCard(0x673) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67200084.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67200084.spfilter,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false)
	local b2=eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_DECK) and Duel.IsPlayerCanDraw(tp,1)
	local b3=eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_EXTRA)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(67200084,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(67200084,3)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(67200084,4)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		local g=eg:Filter(c67200084.desfilter,nil,tp)
		if chk==0 then return Duel.IsExistingMatchingCard(c67200084.filter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c67200084.desop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67200084.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif sel==2 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c67200084.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
end
--to hand
function c67200084.thfilter(c)
	return c:IsSetCard(0x673) and c:IsAbleToHand()
end
function c67200084.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200084.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c67200084.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200084.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
