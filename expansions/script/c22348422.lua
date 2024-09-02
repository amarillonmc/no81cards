--绰影遗迹的诳语先知
local m=22348422
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348422)
	e1:SetCost(c22348422.sumcost)
	e1:SetTarget(c22348422.sumtg)
	e1:SetOperation(c22348422.sumop)
	c:RegisterEffect(e1)
	--to deck top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348422,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,22349422)
	e2:SetTarget(c22348422.tdtg)
	e2:SetOperation(c22348422.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--deckdes
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348422,2))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c22348422.discost)
	e4:SetTarget(c22348422.distg)
	e4:SetOperation(c22348422.disop)
	c:RegisterEffect(e4)
	
end
function c22348422.GetType(c)
	if c:IsType(TYPE_TRAP) then return 1
	elseif c:IsType(TYPE_MONSTER) then return 2
	elseif c:IsType(TYPE_SPELL) then return 3 
	else return nil
	end
end
function c22348422.thcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x970a)
end
function c22348422.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c22348422.thcfilter,1,REASON_COST,true,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c22348422.thcfilter,1,1,REASON_COST,true,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22348422.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c22348422.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc and re:GetHandler() and c22348422.GetType(tc)==c22348422.GetType(re:GetHandler()) and Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c22348422.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c22348422.sumfilter(c)
	return c:IsSetCard(0x970a) and c:IsSummonable(true,nil)
end
function c22348422.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348422.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c22348422.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348422.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c22348422.tdfilter(c)
	return c:IsSetCard(0x970a) or c:IsRace(RACE_ZOMBIE)
end
function c22348422.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348422.tdfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c22348422.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22348422,1))
	local g=Duel.SelectMatchingCard(tp,c22348422.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end

