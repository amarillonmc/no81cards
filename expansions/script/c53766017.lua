if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.Excavated_Check(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.tptg)
	e3:SetOperation(s.tpop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		s.destroyed={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(s.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:GetBaseAttack()==0 and tc:GetOriginalType()&TYPE_MONSTER~=0 then table.insert(s.destroyed,tc:GetCode()) end
	end
end
function s.clear(e,tp,eg,ep,ev,re,r,rp)
	s.destroyed={}
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return #(s.destroyed)>0 and Duel.GetCurrentPhase()==PHASE_END
end
function s.thfilter(c)
	return c:IsSetCard(0x5534) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5534) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local eff=(e:GetHandler():GetFlagEffect(53766099)>0 and 1) or 0
		e:SetLabel(eff)
		local g1=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		return g1:GetClassCount(Card.GetCode)>1 or (g2:GetClassCount(Card.GetCode)>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133))
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local op=aux.SelectFromOptions(tp,{g1:GetClassCount(Card.GetCode)>1,aux.Stringid(id,0)},{g2:GetClassCount(Card.GetCode)>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133),aux.Stringid(id,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
	end
	local c=e:GetHandler()
	if e:GetLabel()==1 and c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE)  then
		Duel.BreakEffect()
		c:CancelToGrave()
		if c:IsAbleToHand() then Duel.SendtoHand(c,nil,REASON_EFFECT) else c:CancelToGrave(false) end
	end
end
function s.handcon(e)
	return e:GetHandler():GetFlagEffect(53766099)>0
end
function s.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_TRAP) end
end
function s.tpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local tc=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP):GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end
