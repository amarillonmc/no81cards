--刻刻帝---「四之弹」
function c33400104.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetLabel(2)
	e1:SetCost(c33400104.cost)
	e1:SetCountLimit(1,33400104+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33400104.condition)
	e1:SetTarget(c33400104.target)
	e1:SetOperation(c33400104.operation)
	c:RegisterEffect(e1)
end
function c33400104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
end
function c33400104.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
		and c:IsSetCard(0x341) 
end
function c33400104.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400104.cfilter,1,nil,tp)
end
function c33400104.spfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400104.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:FilterCount(c33400104.spfilter,nil,e,tp)
		return ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
	end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c33400104.spfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c33400104.spfilter2(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400104.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local sg=eg:Filter(c33400104.spfilter2,nil,e,tp)
	if ft<sg:GetCount() then return end
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	if ct==0 then return end
	if ct>0 then 
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if dg:GetCount()>0 and Duel.GetMatchingGroupCount(c33400104.ss,tp,LOCATION_GRAVE,0,nil)>=3 and Duel.SelectYesNo(tp,aux.Stringid(33400104,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg1=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg1)
			Duel.Destroy(sg1,REASON_EFFECT)
		end
   end
end
function c33400104.ss(c)
	return c:IsSetCard(0x3341) or c:IsSetCard(0x3340)
end
