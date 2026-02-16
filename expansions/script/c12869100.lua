--独一寒霜是双行华符
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return c:IsSetCard(0x6a70) and c:IsAbleToRemoveAsCost()
end
function s.fselect(g,tg)
	return tg:IsExists(Card.IsLink,1,nil,#g)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x6a70)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local _,maxlink=tg:GetMaxGroup(Card.GetLink)
	if chk==0 then return #tg>0 and cg:CheckSubGroup(s.fselect,1,maxlink,tg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:SelectSubGroup(tp,s.fselect,false,1,maxlink,tg)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rg:GetCount())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spfilter1(c,e,tp,lk)
	return s.spfilter(c,e,tp) and c:IsLink(lk)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local lk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lk)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end