--饥献瘴溪兽 玛杜鲁亚
function c19209938.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209938,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DRAW)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,19209938)
	e1:SetCondition(c19209938.spcon)
	e1:SetCost(c19209938.cost)
	e1:SetTarget(c19209938.sptg)
	e1:SetOperation(c19209938.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209938,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c19209938.drcost)
	e2:SetTarget(c19209938.drtg)
	e2:SetOperation(c19209938.drop)
	c:RegisterEffect(e2)
end
function c19209938.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c19209938.costfilter(c,tp)
	return c:IsSetCard(0xb54) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c19209938.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209938.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c19209938.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c19209938.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209938.tffilter(c,tp)
	return c:IsSetCard(0xb54) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and aux.NecroValleyFilter()(c)
end
function c19209938.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetTargetsRelateToChain()
	local b1=#g>0
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c19209938.tffilter,tp,LOCATION_GRAVE,0,1,nil,tp)
	local b3=true
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(19209938,0)},
		{b2,aux.Stringid(19209938,1)},
		{b3,aux.Stringid(19209938,2)})
	if op==1 then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,g)
		local p=1-tp
		local sg=g:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,p,false,false)
		if #sg>0 and Duel.GetMZoneCount(p)>0 and Duel.SelectYesNo(tp,aux.Stringid(19209938,3)) then
			local sc=sg:GetFirst()
			if #sg>1 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
				sc=sg:Select(p,1,1,nil):GetFirst()
			end
			Duel.SpecialSummon(sc,0,p,p,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	elseif op==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c19209938.tffilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c19209938.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xb55,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xb55,2,REASON_COST)
end
function c19209938.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c19209938.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)--Duel.Draw(tp,1,REASON_EFFECT)
end
