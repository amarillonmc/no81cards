local m=15005691
local cm=_G["c"..m]
cm.name="可这界纬璀璨如歌"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15005691)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.atktg)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.sumcost)
	e4:SetTarget(cm.sumtg)
	e4:SetOperation(cm.sumop)
	c:RegisterEffect(e4)
end
function cm.atktg(e,c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function cm.CostFilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,c) and c:IsReleasable()
end
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(cm.CostFilter,e:GetHandler(),tp)
	if chk==0 then return #g1>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g1:Select(tp,1,1,nil)
	local tc=rg:GetFirst()
	aux.UseExtraReleaseCount(rg,tp)
	Duel.Release(tc,REASON_COST)
end
function cm.sumfilter(c)
	return c:IsSummonable(true,nil,1)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end