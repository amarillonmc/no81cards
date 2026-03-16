local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	s.AddVariableRankXyzProcedure(c,nil,2,99)
	c:EnableReviveLimit()
	--rank up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_RANK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.rkval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.rkval(e,c)
	return c:GetOverlayCount()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckLPCost(tp,c:GetRank()*500) end
	Duel.PayLPCost(tp,c:GetRank()*500)
end
function s.spfilter(c,e,tp,rk)
	return c:IsType(TYPE_XYZ) and c:IsRank(rk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rk=c:GetRank()
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and c:GetOverlayCount()>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rk=c:GetRank()
	if Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			if c:IsRelateToEffect(e) and c:GetOverlayCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
				local mg=c:GetOverlayGroup():Select(tp,1,1,nil)
				local oc=mg:GetFirst():GetOverlayTarget()
				Duel.Overlay(tc,mg)
				Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
				Duel.RaiseEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0x1f)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.AddVariableRankXyzProcedure(c,f,minct,maxct)
	if not maxct then maxct=minct end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.VariableRankXyzCondition(f,minct,maxct))
	e1:SetTarget(s.VariableRankXyzTarget(f,minct,maxct))
	e1:SetOperation(s.VariableRankXyzOperation(f,minct,maxct))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end

-- 辅助：获取当前符合条件的阶级列表
function s.GetVariableRankValidRanks(c,tp,mg,f,minc,maxc)
	local valid_ranks={}
	-- 遍历1到12阶 (根据需要可调整范围)
	for k=1,12 do
		-- 临时改变阶级
		local e_rank=Effect.CreateEffect(c)
		e_rank:SetType(EFFECT_TYPE_SINGLE)
		e_rank:SetCode(EFFECT_CHANGE_RANK)
		e_rank:SetValue(k)
		e_rank:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		c:RegisterEffect(e_rank,true)
		
		-- 使用 CheckXyz2XMaterial 进行全功能检查 (包含1当2逻辑)
		-- 注意：如果 minc<3，CheckXyz2XMaterial 内部通常会退化为普通检查，
		-- 但为了保险，我们手动分流，确保逻辑覆盖
		local res = false
		if minc>=3 and mg:IsExists(Auxiliary.Xyz2XMaterialEffectFilter,1,nil,c,k,f,tp) then
			 res = Auxiliary.CheckXyz2XMaterial(c,f,k,minc,maxc,mg)
		else
			 -- 即使是普通检查，也要检查 minc <= maxc
			 if minc <= maxc then
				 res = Duel.CheckXyzMaterial(c,f,k,minc,maxc,mg)
			 end
		end
		
		if res then valid_ranks[k]=true end
		e_rank:Reset()
	end
	return valid_ranks
end

-- 核心目标函数：检查选中的卡组 g 是否满足任意一个合法阶级的要求
function s.VariableRankXyzGoal(valid_ranks, xyzc, f, minc, maxc)
	return function(g,tp)
		if Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then return false end
		for k,v in pairs(valid_ranks) do
			if v then
				-- 1. 检查等级一致性：所有卡必须都能作为阶级 k 的素材
				local all_level_match = true
				for tc in aux.Next(g) do
					if not (tc:IsXyzLevel(xyzc, k) and (not f or f(tc, xyzc))) then
						all_level_match = false
						break
					end
				end
				
				if all_level_match then
					-- 2. 调用官方辅助函数检查数量和特殊效果
					-- Xyz2XMaterialGoal 负责检查：位置是否足够、1当2效果、数量是否>=minc
					-- 注意：Xyz2XMaterialGoal 内部会再次检查 LocationCountFromEx
					if Auxiliary.Xyz2XMaterialGoal(g, tp, xyzc, minc) then
						return true
					end
				end
			end
		end
		return false
	end
end

function s.VariableRankXyzCondition(f,minct,maxct)
	return function(e,c,og,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg=nil
		if og then mg=og else mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0) end
		
		local minc=minct
		local maxc=maxct
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
		end
		
		local valid_ranks = s.GetVariableRankValidRanks(c,tp,mg,f,minc,maxc)
		for k,v in pairs(valid_ranks) do
			if v then return true end
		end
		return false
	end
end

function s.VariableRankXyzTarget(f,minct,maxct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
		if og and not min then return true end
		local minc=minct
		local maxc=maxct
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
		end
		local mg=nil
		if og then mg=og else mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0) end
		
		-- 1. 必须使用的素材处理
		local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
		-- 如果必须使用的素材本身就不符合基本条件，直接返回false
		if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
		
		-- 2. 获取合法阶级
		-- 这一步非常重要，它预先过滤掉了因为“禁止X阶召唤”而不可用的阶级
		local valid_ranks = s.GetVariableRankValidRanks(c,tp,mg,f,minc,maxc)
		if next(valid_ranks) == nil then return false end

		-- 3. 准备素材池
		-- 过滤掉那些完全不可能被选中的卡（即不符合任何合法阶级等级的卡）
		local valid_materials = mg:Filter(function(tc)
			for k,v in pairs(valid_ranks) do
				if v and tc:IsCanBeXyzMaterial(c) and tc:IsXyzLevel(c, k) and (not f or f(tc, c)) then
					return true
				end
			end
			return false
		end, nil)
		
		-- 4. 设定必须选中的卡
		Duel.SetSelectedCard(sg)
		
		-- 5. 让玩家选择
		-- minc 设为 1 而不是 minc，是因为如果存在“1当2”的怪兽，可能只需要1张卡就满足 minc=2 的要求
		-- 具体的数量检查由 VariableRankXyzGoal 里的 Auxiliary.Xyz2XMaterialGoal 完成
		local select_min = 1
		-- 如果没有特殊效果，且 sg 为空，理论上 select_min 可以优化，但为了安全设为 1
		
		local cancel=Duel.IsSummonCancelable()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		
		-- 核心：使用 SelectSubGroup 配合我们增强的 Goal 函数
		local g=valid_materials:SelectSubGroup(tp, s.VariableRankXyzGoal(valid_ranks, c, f, minc, maxc), cancel, select_min, maxc)
		
		if g and #g>0 then
			g:KeepAlive()
			e:SetLabelObject(g)
			
			-- 6. 反推阶级
			local matched_ranks = {}
			for k,v in pairs(valid_ranks) do
				if v then
					local all_match = true
					for tc in aux.Next(g) do
						if not (tc:IsXyzLevel(c, k) and (not f or f(tc, c))) then
							all_match = false
							break
						end
					end
					-- 必须同时满足数量/特殊效果要求
					if all_match and Auxiliary.Xyz2XMaterialGoal(g, tp, c, minc) then
						table.insert(matched_ranks, k)
					end
				end
			end
			
			local final_rank = matched_ranks[1]
			if #matched_ranks > 1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LVRANK)
				final_rank = Duel.AnnounceNumber(tp, table.unpack(matched_ranks))
			end
			
			e:SetLabel(final_rank)
			return true
		else 
			return false 
		end
	end
end

function s.VariableRankXyzOperation(f,minct,maxct)
	return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
		local mg=nil
		if og and not min then
			mg=og
		else
			mg=e:GetLabelObject()
			local mg2=mg:GetFirst():GetOverlayGroup()
			if mg2:GetCount()~=0 then
				Duel.Overlay(c,mg2)
			end
		end
		
		-- 处理“1当2”的特殊计数逻辑 (移除多余的计数指示物等)
		-- 官方的 Xyz2XMaterialOperation 会处理 EFFECT_DOUBLE_XMATERIAL 的计数重置等
		if not og or min then
			Auxiliary.Xyz2XMaterialOperation(tp,mg,c,minct,maxct)
			local sg=Group.CreateGroup()
			local tc=mg:GetFirst()
			while tc do
				local sg1=tc:GetOverlayGroup()
				sg:Merge(sg1)
				tc=mg:GetNext()
			end
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		
		if not og or min then
			mg:DeleteGroup()
		end
		
		local final_rank=e:GetLabel()
		if final_rank and final_rank>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RANK)
			e1:SetValue(final_rank)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e1)
		end
	end
end