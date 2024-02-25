--I:P路由助手
local s,id,o=GetID()
function c98920531.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK)),2,2)
	c:EnableReviveLimit()
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920531,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920531)
	e1:SetCondition(c98920531.lkcon)
	e1:SetTarget(c98920531.lktg)
	e1:SetOperation(c98920531.lkop)
	c:RegisterEffect(e1)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCondition(s.spcon)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
end
function c98920531.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c98920531.tgfilter(c,tp,ec,g)
	local mg=Group.FromCards(ec,c)
	return g:IsContains(c) and c:IsFaceup() and Duel.IsExistingMatchingCard(c98920531.lfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c98920531.lfilter(c,mg)
	return c:IsLinkSummonable(mg,nil,2,2)
end
function c98920531.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.IsExistingTarget(c98920531.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp,e:GetHandler(),lg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920531.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetLinkedGroup()
	local g=Duel.GetMatchingGroup(c98920531.tgfilter,tp,0,LOCATION_MZONE,nil,tp,c,cg)
	if g:GetCount()>0 then
		 tc=g:GetFirst()
		 if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp)
			and tc:IsFaceup() and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) then
			local mg=Group.FromCards(c,tc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c98920531.lfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
			local lc=g:GetFirst()
			if lc then
			   Duel.LinkSummon(tp,lc,mg,nil,2,2)
			end
		 end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	e1:SetValue(2)
	Duel.RegisterEffect(e1,tp)
end