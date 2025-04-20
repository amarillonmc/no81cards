local cm,m=GetID()

function cm.initial_effect(c)
	-- 效果①
	aux.AddCodeList(c,71521025)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	-- 效果②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+5)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

-- 效果① Cost (除外墓地1张卡)
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

-- 效果① 解放检查

function cm.release_filter(g)
	return  g:FilterCount(Card.IsType,nil,TYPE_FUSION)>0
and g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)>0
and g:FilterCount(Card.IsType,nil,TYPE_XYZ)>0
and g:FilterCount(Card.IsType,nil,TYPE_LINK)>0
end
function cm.fit(c)
	return c:IsReleasableByEffect()
end
-- 效果① Target (选择特殊召唤方式)
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.fit,tp,LOCATION_MZONE,0,nil)
		local check_alt=g:CheckSubGroup(cm.release_filter)
		return  (Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and #g>3
			or (check_alt and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_GRAVE_SPSUMMON,nil,1,tp,0)
end

-- 效果① SpecialSummon过滤器
function cm.spfilter1(c,e,tp)
	return c:IsCode(71521025) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.spfilter2(c,e,tp)
	return c:IsCode(71527471) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.fitn(g,e,tp)
	return (g:FilterCount(Card.IsType,nil,TYPE_FUSION)>0 and g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)>0 and g:FilterCount(Card.IsType,nil,TYPE_XYZ)>0 and g:FilterCount(Card.IsType,nil,TYPE_LINK)>0 and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)) or Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
end
-- 效果①操作
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.fit,tp,LOCATION_MZONE,0,nil)
	if #g<4  then return end
	local rg=g:SelectSubGroup(tp,cm.fitn,false,4,4,e,tp)
	-- 解放检查
	if Duel.Release(rg,REASON_EFFECT)~=4 then return end
	-- 判断是否能特殊召唤特殊类型
	local g2=Duel.GetOperatedGroup()
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter1),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local b2=g2:FilterCount(Card.IsType,nil,TYPE_FUSION)>0 
		and g2:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)>0 
		and g2:FilterCount(Card.IsType,nil,TYPE_XYZ)>0 
		and g2:FilterCount(Card.IsType,nil,TYPE_LINK)>0
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if b2 then 
		local g3=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp)
		g1:Merge(g3)
	end
	local spg=g1:Select(tp,1,1,nil)   
		local tc=spg:GetFirst()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,true,true,POS_FACEUP) then
			-- 攻击力变化效果
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(g2:GetSum(Card.GetAttack)+g2:GetSum(Card.GetDefense))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			-- 效果抗性
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetValue(cm.efilter1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end

end

function cm.efilter1(e,te)
	return te:IsActiveType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end

-- 效果② Cost
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end 
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 效果② Target
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(cm.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function cm.spfilter3(c,e,tp)
	return c:IsCode(71521025) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 效果②操作
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			-- 效果抗性
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(cm.efilter2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			-- 战斗破坏抗性
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetValue(1)
			tc:RegisterEffect(e2)
		end
	end
end

function cm.efilter2(e,te)
	return te:GetOwner()~=e:GetOwner() 
end
