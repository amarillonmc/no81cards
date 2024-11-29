--先导的异骑士
local cm,m=GetID()
function cm.initial_effect(c)
	--setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_DECK)
	e1:SetValue(0xc976)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetValue(0xc977)
	c:RegisterEffect(e4)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_DECK)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--s summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(cm.scon)
	e3:SetTarget(cm.stg)
	e3:SetOperation(cm.sop)
	c:RegisterEffect(e3)
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.sfilter(c,mc,mg)
	return c:IsSynchroSummonable(mc,mg) or c:IsLinkSummonable(mg,mc) or mg:CheckSubGroup(cm.xfilter,1,#mg,c,mc)
end
function cm.xfilter(g,c,mc)
	return g:IsContains(mc) and c:IsXyzSummonable(g,#g,#g)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsLevel,tp,LOCATION_HAND,0,nil,1)
	if chk==0 then return mg:IsContains(c) and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_EXTRA,0,1,nil,c,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsLevel,tp,LOCATION_HAND,0,nil,1)
	if not c:IsRelateToEffect(e) or not mg:IsContains(c) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,c,mg):GetFirst()
	if not tc then return end
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabelObject(tc)
	e2:SetCondition(cm.descon)
	e2:SetOperation(aux.EPDestroyOperation)
	Duel.RegisterEffect(e2,tp)
	if tc:IsSynchroSummonable(c,mg) then
		Duel.SynchroSummon(tp,tc,c,mg)
	elseif tc:IsLinkSummonable(mg,c) then
		Duel.LinkSummon(tp,tc,mg,c)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg2=mg:SelectSubGroup(tp,cm.xfilter,false,1,#mg,tc,c)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.handop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e3=e1:Clone()
		e3:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(e3,tp)
		Duel.XyzSummon(tp,tc,mg2,0)
	end
end
function cm.handop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleHand(tp)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end