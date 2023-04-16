--永夏的畅行
require("expansions/script/c9910950")
function c9910976.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910976+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910976.cost)
	e1:SetTarget(c9910976.target)
	e1:SetOperation(c9910976.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_BATTLE_START)
	e2:SetCountLimit(1,9910983)
	e2:SetCondition(c9910976.atkcon)
	e2:SetCost(c9910976.atkcost)
	e2:SetTarget(c9910976.atktg)
	e2:SetOperation(c9910976.atkop)
	c:RegisterEffect(e2)
end
function c9910976.rmfilter(c)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c9910976.fselect(g,e,tp)
	return aux.gffcheck(g,Card.IsType,TYPE_TUNER,aux.NOT(Card.IsType),TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c9910976.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g:GetSum(Card.GetLevel))
end
function c9910976.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910976.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local g=Duel.GetMatchingGroup(c9910976.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then
		return g:CheckSubGroup(c9910976.fselect,2,2,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c9910976.fselect,false,2,2,e,tp)
	e:SetLabel(sg:GetSum(Card.GetLevel))
	Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
end
function c9910976.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910976.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local res=false
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910976.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if #g>0 then
		res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
function c9910976.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
end
function c9910976.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost(POS_FACEDOWN) end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Remove(c,POS_FACEDOWN,REASON_COST)
end
function c9910976.filter(c)
	return c:IsSetCard(0x5954) and c:IsFaceup()
end
function c9910976.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910976.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c9910976.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910976.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
