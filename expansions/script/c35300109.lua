--龙源魔影
local m=35300109
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--apply
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp,rp)
	return c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:GetPreviousTypeOnField()&TYPE_SYNCHRO~=0
		and c:IsReason(REASON_COST+REASON_EFFECT) and rp==tp
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,rp)
end
function cm.spfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or (c:IsFaceup() and c:IsLocation(LOCATION_REMOVED))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:Filter(cm.cfilter,nil,tp,rp):IsExists(cm.spfilter,1,nil,e,tp) and Duel.GetFlagEffect(tp,m)==0
		local b2=Duel.IsExistingMatchingCard(cm.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,m+1)==0
		return b1 or b2 
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:Filter(cm.cfilter,nil,tp,rp):IsExists(cm.spfilter,1,nil,e,tp) and Duel.GetFlagEffect(tp,m)==0
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.rfilter),tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,m+1)==0
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local sg=eg:Filter(cm.cfilter,nil,tp,rp):Filter(cm.spfilter,nil,e,tp)
		if #sg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg:Select(tp,1,1,nil)
		end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rfilter),tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
		Duel.HintSelection(rg)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	end
end