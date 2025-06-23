--呼朋引伴
local s,id,o=GetID()
function c13000773.initial_effect(c)
c:SetSPSummonOnce(13000773)
c:EnableReviveLimit()
 aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK),3,3)
 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65741786,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.lkcon)
	e1:SetTarget(s.lktg)
	e1:SetOperation(s.lkop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(s.indcon)
	e2:SetOperation(s.indop)
	c:RegisterEffect(e2)
end

function s.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_BE_MATERIAL)
		e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
		e4:SetCondition(s.effcon)
		e4:SetOperation(s.effop1)
		c:RegisterEffect(e4,true)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
end
function s.effop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(s.sumop)
	rc:RegisterEffect(e1,true)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(13000773,0)) then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
	end
end
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function s.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65741786,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.lkcon)
	e1:SetTarget(s.lktg)
	e1:SetOperation(s.lkop)
	rc:RegisterEffect(e1)
end
function s.indval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end