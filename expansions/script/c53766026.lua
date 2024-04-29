if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.Excavated_Check(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_END_PHASE)
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
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.regcon)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(s.tgcon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.tgtg)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
	SNNM.Not_Destroyed_Check(c)
end
function s.handcon(e)
	return e:GetHandler():GetFlagEffect(53766099)>0
end
function s.filter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsFaceup() and c:GetFlagEffect(53766008)>0
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,2,nil)
end
function s.tdfilter(c)
	return c:GetSequence()<5 and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToDeck() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c):GetFirst()
	if tc:GetOriginalType()&TYPE_MONSTER~=0 and tc:IsFaceup() and tc:GetFlagEffect(53766008)>0 and tc:IsControler(tp) and c:IsStatus(STATUS_ACT_FROM_HAND) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and e:GetLabel()==1 then Duel.BreakEffect() Duel.SkipPhase(Duel.GetTurnPlayer(),Duel.GetCurrentPhase(),RESET_PHASE+Duel.GetCurrentPhase(),1,1) end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
