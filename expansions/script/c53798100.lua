local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--Global Check (Track activation on own turn)
	--Ref 陀羅威 global_check logic
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	--Effect 1: Banish Special Summoned monsters
	--Ref 闇の閃光 (Handling "monsters Special Summoned this turn")
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)

	--Effect 2: Negate and Banish
	--Ref 透破抜き (Negate and remove logic)
	--Ref 神の警告 (Cost logic)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.negcon)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	--Logic based on 陀羅威, but checks "Turn Player is Activated Player"
	--Registers flag if card activates effect during controller's turn.
	if Duel.GetTurnPlayer()==ep then
		--Flag persists on the monster (RESET_EVENT+RESETS_STANDARD) so it is remembered for opponent's turn
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

--Helper: Restriction Logic
--Ref 破滅のフォトン・ストリーム (Turn player check)
function s.turn_condition(e,tp)
	-- If it's own turn, no restriction.
	if Duel.GetTurnPlayer()==tp then return true end
	-- If it's not own turn, must have activated effect on own turn (Flag > 0)
	return e:GetHandler():GetFlagEffect(id)>0
end

--Effect 1 Functions
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and s.turn_condition(e,tp)
end

function s.rmfilter(c)
	--Ref 闇の閃光 (IsStatus STATUS_SPSUMMON_TURN)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsAbleToRemove(POS_FACEDOWN)
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

--Effect 2 Functions
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	--Ref 神の警告 (Checking category/type logic structure)
	--Exclude effects that include negate activation (CATEGORY_NEGATE) or negate effects (CATEGORY_DISABLE)
	if re:IsHasCategory(CATEGORY_NEGATE) or re:IsHasCategory(CATEGORY_DISABLE) then return false end
	return rp==1-tp and s.turn_condition(e,tp) and Duel.IsChainNegatable(ev)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--Ref 神の警告 (PayLPCost logic adapted for Half LP)
	if chk==0 then return Duel.CheckLPCost(tp,math.floor(Duel.GetLP(tp)/2)) end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	--Ref 透破抜き (Negate and Remove)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end