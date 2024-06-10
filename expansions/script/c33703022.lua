--虚拟YouTuber的飞升
local cm,m,o=GetID()
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetTarget(cm.tg)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return (c:IsSetCard(0x344c) or c:IsSetCard(0x445)) and c:IsAbleToRemove() and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_DECK,0,1,c)
end
function cm.filter1(c)
	return (c:IsSetCard(0x344c) or c:IsSetCard(0x445)) and c:IsAbleToRemove() and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)>0 then return end
	local c=e:GetHandler()
	local rc=1
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if g and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_REMOVED) then
		local sg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_DECK,0,nil)
		if sg and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
			rc=rc+Duel.GetOperatedGroup():GetCount()
			local rg=Group.CreateGroup()
			local rg1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
			if rc>0 and rg1:GetCount()>0 and rc>=rg1:GetCount() then
				rg:Merge(rg1)
				rc=rc-rg1:GetCount()
			elseif rg1:GetCount()>0 then
				local rgs=rg1:Select(tp,rc,rc,nil)
				rg:Merge(rgs)
				Duel.HintSelection(rgs)
				rc=0
			end
			local rg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE,nil)
			if rc>0 and rg2:GetCount()>0 and rc>=rg2:GetCount() then
				rg:Merge(rg2)
				rc=rc-rg2:GetCount()
			elseif rg2:GetCount()>0 then
				local rgs=rg2:Select(tp,rc,rc,nil)
				rg:Merge(rgs)
				Duel.HintSelection(rgs)
				rc=rc-rg2:GetCount()
			end
			if rc>0 then
				local rg3=Duel.GetDecktopGroup(1-tp,rc)
				rg:Merge(rg3)
				Duel.DisableShuffleCheck()
				rc=0
			end
			local rg4=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
			if rc>0 and rg4:GetCount()>0 and rc>=rg4:GetCount() then
				local rgs=rg4:RandomSelect(tp,rc)
				rg:Merge(rgs)
			end
			if rg then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) end
		end
	end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    Duel.RegisterEffect(e2,tp)
end