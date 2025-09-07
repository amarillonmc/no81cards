--炯炯的焰之遗志
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_NORMALSUMMON,s.counterfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return c:IsSetCard(0xc30)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_NORMALSUMMON)==0 and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc30)
end
function s.tfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsOriginalSetCard(0xc30)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
	local n=Duel.GetMatchingGroup(tfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if chk==0 then return Duel.IsPlayerCanRemove(1-tp) and g:IsExists(Card.IsAbleToRemove,n,nil,1-tp,POS_FACEUP,REASON_RULE) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.rtfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc30) and c:IsAbleToDeck()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanRemove(1-tp) then return end
	local g=Duel.GetMatchingGroup(s.rfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,nil,1-tp,POS_FACEUP,REASON_RULE)
	if g:GetCount()>0 then
		local n=Duel.GetMatchingGroup(s.tfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,n,n,nil)
		if sg:GetCount()>0 then
			local rn=Duel.Remove(sg,POS_FACEUP,REASON_RULE,1-tp)
			local rg=Duel.GetMatchingGroup(s.rtfilter,tp,LOCATION_GRAVE,0,nil)
			if rn>0 and #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local rg1=rg:Select(1-tp,1,rn,nil)
				if #rg1>0 then
					Duel.SendtoDeck(rg1,nil,2,REASON_EFFECT)
				end
			end
		end
	end
end
