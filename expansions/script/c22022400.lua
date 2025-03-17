--人理之基 勇者伊丽莎白
function c22022400.initial_effect(c)
	aux.AddCodeList(c,22020850)
	c:EnableReviveLimit()
	--material
	aux.AddMaterialCodeList(c,22020850)
	aux.AddFusionProcFunRep(c,c22022400.ffilter,2,true)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(22022400,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22022401)
	e1:SetTarget(c22022400.target)
	e1:SetOperation(c22022400.operation)
	c:RegisterEffect(e1)
	--deck top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022400,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,22022400+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c22022400.cost)
	e2:SetTarget(c22022400.tptg)
	e2:SetOperation(c22022400.tpop)
	c:RegisterEffect(e2)
	--draw ere
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(22022400,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22022401)
	e3:SetCondition(c22022400.erecon)
	e3:SetCost(c22022400.erecost)
	e3:SetTarget(c22022400.target)
	e3:SetOperation(c22022400.operation)
	c:RegisterEffect(e3)
	--deck top
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22022400,4))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,22022400+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c22022400.erecon)
	e4:SetCost(c22022400.cost1)
	e4:SetTarget(c22022400.tptg)
	e4:SetOperation(c22022400.tpop)
	c:RegisterEffect(e4)
end
function c22022400.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionCode(22020850) or aux.IsCodeListed(c,22020850)
end
function c22022400.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SelectOption(tp,aux.Stringid(22022400,6))
end
function c22022400.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(22022400,2)) then
				Duel.SelectOption(tp,aux.Stringid(22022400,7))
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				Duel.SelectOption(tp,aux.Stringid(22022400,8))
			end
		elseif tc:IsType(TYPE_SPELL) and c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.SelectOption(tp,aux.Stringid(22022400,9))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(c:GetAttack()*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(c:GetDefense()*2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e2)
			Duel.SelectOption(tp,aux.Stringid(22022400,10))
		elseif tc:IsType(TYPE_TRAP) and c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SelectOption(tp,aux.Stringid(22022400,11)) then
			if c:IsRelateToEffect(e) and Duel.SelectOption(tp,aux.Stringid(22022400,12)) then
				Duel.Destroy(c,REASON_EFFECT)
			end
		end
		Duel.ShuffleHand(tp)
	end
end
function c22022400.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp-2400,true) end
	e:SetLabel(lp-2400)
	Duel.PayLPCost(tp,lp-2400,true)
end
function c22022400.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c22022400.tpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22022400,5))
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.SelectOption(tp,aux.Stringid(22022400,13))
	end
end
function c22022400.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22022400.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22022400.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp-2400,true) end
	e:SetLabel(lp-2400)
	Duel.PayLPCost(tp,lp-2400,true)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end