local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 超量召唤手续
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165) -- "超量召唤"
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(s.xyzcon)
	e0:SetTarget(s.xyztg)
	e0:SetOperation(s.xyzop)
	c:RegisterEffect(e0)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.relcon)
	e2:SetTarget(s.reltg)
	e2:SetOperation(s.relop)
	c:RegisterEffect(e2)

end

-- 素材过滤器：5星怪兽 或 场地区域的表侧卡
function s.mfilter(c,xyzc,tp)
	-- 场地区域的卡 (双方)
	if c:IsLocation(LOCATION_FZONE) then
		return c:IsFaceup() -- 只要是表侧的场地卡即可，文本描述将其“作为5星怪兽”使用
	end
	-- 己方怪兽区域的卡
	return c:IsFaceup() and c:IsLevel(5) and c:IsCanBeXyzMaterial(xyzc)
end

-- 检查子集是否满足召唤条件 (Goal)
function s.xyzcheck(g,tp,xyzc)
	-- 必须满足额外卡组出场的位置要求
	if Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then return false end
	
	-- 兼容性检查：EFFECT_XYZ_MIN_COUNT (例如某些卡要求必须包含X张素材)
	for c in aux.Next(g) do
		local le=c:IsHasEffect(EFFECT_XYZ_MIN_COUNT)
		if le then
			local ct=le:GetValue()
			if #g<ct then return false end
		end
	end
	return true
end

-- 召唤条件 Condition
function s.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	if maxc<minc then return false end

	local mg=nil
	if og then
		mg=og
	else
		-- 获取己方MZONE的怪兽 和 双方FZONE的卡
		mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE+LOCATION_FZONE,LOCATION_FZONE,nil,c,tp)
	end

	-- 兼容性检查：必须作为超量素材的卡 (Must Material)
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)

	-- 兼容性检查：调弦之魔术师等限制 (GCheckAdditional)
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local res=mg:CheckSubGroup(s.xyzcheck,minc,maxc,tp,c)
	aux.GCheckAdditional=nil
	return res
end

-- 召唤目标 Target
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE+LOCATION_FZONE,LOCATION_FZONE,nil,c,tp)
	end

	-- 兼容性检查：Must Material
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)

	-- 兼容性检查：GCheckAdditional
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	
	local cancel=Duel.IsSummonCancelable()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=mg:SelectSubGroup(tp,s.xyzcheck,cancel,minc,maxc,tp,c)
	
	aux.GCheckAdditional=nil

	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else 
		return false 
	end
end

-- 召唤操作 Operation
function s.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		-- 极其罕见的情况：通过其他卡片效果直接给予og作为素材
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		-- 正常流程
		local mg=e:GetLabelObject()
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.atchcon)
	e1:SetOperation(s.atchop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.atchcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	return c:GetFlagEffect(id)~=0
		and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c)
end
function s.atchop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if c:GetFlagEffect(id)==0 or not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,c)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function s.relcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local ct=c:GetOverlayCount()
		for i,p in ipairs({tp,1-tp}) do
			if Duel.GetFieldGroupCount(p,LOCATION_MZONE,0)>ct then return true end
		end
		return false
	end
end
function s.relop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=c:GetOverlayCount()
	local g=Group.CreateGroup()
	for i,p in ipairs({tp,1-tp}) do
		local mg=Duel.GetFieldGroup(p,LOCATION_MZONE,0)
		if mg:GetCount()>ct then
			local count=mg:GetCount()-ct
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_RELEASE)
			local sg=Duel.SelectReleaseGroupEx(p,nil,count,count,REASON_EFFECT,false,nil)
			if sg then g:Merge(sg) end
		end
	end
	if g:GetCount()>0 then
		Duel.Release(g,REASON_EFFECT)
	end
end