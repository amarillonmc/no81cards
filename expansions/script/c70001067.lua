--炎帝王 泰斯塔罗斯
local m=70001067
local cm=_G["c"..m]
function cm.initial_effect(c)
	--set s/t
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.con)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
	function cm.filter(c)
	return c:IsCode(48716527) and c:IsSSetable()
end
	function cm.filter2(c)
	return c:IsAttackAbove(2400) and c:IsDefense(1000) and c:IsAttribute(ATTRIBUTE_WATER)
end
	function cm.filter3(c)
	return c:IsCode(18235309) and c:IsSSetable()
end
	function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
	function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then Duel.SSet(tp,tc)
	if Duel.GetMatchingGroupCount(cm.filter2,tp,LOCATION_MZONE,0,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc2=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc2 then Duel.SSet(tp,tc2)
			end
		end
	end
end
	function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0 and rp==1-tp
end
	function cm.sfilter(c,e,tp)
	return c:IsAttackAbove(2400) and c:IsDefense(1000) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSummonable(true,nil)
end
	function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
	function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	if sg:GetCount()>0 then
	Duel.Summon(tp,sg:GetFirst(),true,nil)
	end
end