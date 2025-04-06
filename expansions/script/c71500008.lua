local cm,m=GetID()

function cm.initial_effect(c)
	-- 效果①：从额外卡组送墓，特殊召唤衍生物
	aux.AddCodeList(c,71521025)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	-- 效果②：除外自身，盖放陷阱
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.con2)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

-- 效果①：条件 - 自己场上不存在怪兽
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end

-- 效果①：目标
function cm.release_filter(c)
	return c:IsReleasable() and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function cm.check_type_group(g)
	local has_fusion=0
	local has_synchro=0
	local has_xyz=0
	local has_link=0
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_FUSION) then has_fusion=1 end
		if tc:IsType(TYPE_SYNCHRO) then has_synchro=1 end
		if tc:IsType(TYPE_XYZ) then has_xyz=1 end
		if tc:IsType(TYPE_LINK) then has_link=1 end
	end
	return (has_fusion+has_synchro+has_xyz+has_link)==4 
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(cm.release_filter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return   g:CheckSubGroup(cm.check_type_group,4) and Duel.GetLocationCount(tp,LOCATION_MZONE)>3 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonMonster(tp,71500022,nil,TYPES_TOKEN_MONSTER,2000,0,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
end

-- 效果①：操作
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local ng=Duel.GetMatchingGroup(cm.release_filter,tp,LOCATION_EXTRA,0,nil)
	-- 依次选择四个类型的各1张
	
	if not ng:CheckSubGroup(cm.check_type_group,4) or Duel.GetLocationCount(tp,LOCATION_MZONE)<4 or Duel.IsPlayerAffectedByEffect(tp,59822133) or not Duel.IsPlayerCanSpecialSummonMonster(tp,71500022,nil,TYPES_TOKEN_MONSTER,2000,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local c=e:GetHandler()
	local tg=ng:SelectSubGroup(tp,cm.check_type_group,false,4,4)
	if #tg==4 and Duel.SendtoGrave(tg,REASON_EFFECT)==4 then
		local tc=tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=tg:GetNext()
		end
	end
	-- 特殊召唤衍生物
	for i=1,4 do
		local token=Duel.CreateToken(tp,71500022)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetAbsoluteRange(tp,1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
	-- 限制额外卡组特殊召唤
end

-- 效果①：额外卡组筛选
function cm.filter1(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) 
end

-- 效果①：限制额外卡组特殊召唤
function cm.splimit(e,c)
	return  c:IsLocation(LOCATION_EXTRA)
end

-- 效果②：条件 - 自己场上没有怪兽或有「幽世之血樱」
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil))
end

-- 效果②：成本 - 除外自身
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 效果②：目标
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end

-- 效果②：操作
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter3),tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end

-- 效果②：「幽世之血樱」筛选
function cm.filter2(c)
	return c:IsCode(71521025) and c:IsFaceup()
end

-- 效果②：陷阱卡筛选
function cm.filter3(c)
	return c:IsType(TYPE_TRAP) and (aux.IsCodeListed(c,71521025)or c:IsCode(65899925,71500007,71500010,71500012,71500015,71527471)) and c:IsSSetable() and not c:IsCode(m)
end
