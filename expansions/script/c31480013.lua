local m=31480013
local cm=_G["c"..m]
cm.name="新生的神欲"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.lktg)
	e1:SetOperation(cm.lkop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:IsFaceup()
end
function cm.lkfilter(c,mg)
	return c:IsSetCard(0x1313) and c:IsLinkSummonable(mg)
end
function cm.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_ONFIELD,0,nil)
		return Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=tg:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,mg)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_GRAVE) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		local lp=Duel.GetLP(c:GetControler())
		Duel.SetLP(c:GetControler(),lp-500)
	end
end