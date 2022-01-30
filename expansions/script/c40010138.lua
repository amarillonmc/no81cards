--惩处的击退者
local m=40010138
local cm=_G["c"..m]
cm.named_with_Revenger=1
function cm.Revenger(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Revenger
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)  
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)  
end
function cm.cfilter(c)
	return c:IsFaceup() and (cm.Revenger(c) or c:IsCode(40010072)) and c:IsReleasableByEffect()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dt==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local cg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,dt,nil)
	if cg:GetCount()>0 then
		ct=Duel.Release(cg,REASON_EFFECT)

		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function cm.spfilter(c,e,tp)
	return cm.Revenger(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if dt==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local cg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,dt,nil)

	if cg:GetCount()>0 then
		ct=Duel.Release(cg,REASON_EFFECT)
		--local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ct,nil,e,tp)
		local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=sg:SelectSubGroup(tp,aux.dncheck,false,1,ct)
			Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end



