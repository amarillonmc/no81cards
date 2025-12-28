--落日残响迷想幻行
local s,id,o=GetID()
function s.initial_effect(c)
	--盖放的回合也能发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(s.actcon)
	c:RegisterEffect(e0)
	
	--①：手卡放置 (二速 + 同连锁限1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(s.placecon)
	e1:SetCost(s.placecost)
	e1:SetTarget(s.placetg)
	e1:SetOperation(s.placeop)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	c:RegisterEffect(e1)
	
	--②：发动效果 (额外解放 -> 加攻 -> 自毁)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	
	--③：被其他卡解放 -> 融合召唤
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_RELEASE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.fuscon)
	e3:SetTarget(s.fustg)
	e3:SetOperation(s.fusop)
	c:RegisterEffect(e3)
	
	--全局检查
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

-- === 盖放检测逻辑 ===
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:GetHandler():IsSetCard(0x614) then return end
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end

function s.actcon(e)
	return e:GetHandler():GetFlagEffect(id)>0
end

-- === 效果①：手卡放置 ===
function s.placecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end

function s.placecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end

function s.placetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.placeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

-- === 效果②：发动效果 ===
function s.exfilter(c)
	-- 模拟解放：能送墓
	return c:IsSetCard(0x614) and c:IsType(TYPE_FUSION) and c:IsAbleToGrave()
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_EXTRA)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	-- 1. 额外卡组解放
	local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RELEASE)>0 then
		-- 2. 选怪兽加攻
		local val=tc:GetTextAttack()
		if val>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
			local sc=sg:GetFirst()
			if sc then
				Duel.HintSelection(sg)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(val)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
			end
		end
	end
	
	-- 3. 自毁
	if c:IsRelateToEffect(e) and c:IsOnField() then
		Duel.BreakEffect()
		Duel.Release(c,REASON_EFFECT)
	end
end

-- === 效果③：融合召唤 ===

function s.fuscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- EVENT_RELEASE 触发时，c 已在目的地 (墓地/除外区)，IsReason(REASON_EFFECT) 可直接判断是否为效果导致
	-- 检查 re 是否存在且不是自身
	return c:IsReason(REASON_EFFECT) and re and re:GetHandler()~=c
end

-- 手卡/场上素材 (解放)
function s.mfilter1(c,e)
	return c:IsReleasableByEffect() and not c:IsImmuneToEffect(e)
end
-- 墓地素材 (除外)
function s.mfilter2(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end

-- 普通融合 (仅手卡/场上)
function s.spfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and c:CheckFusionMaterial(m,nil,chkf)
end
-- 本家融合 (手卡/场上 + 墓地最多1张)
function s.spfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x614) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		-- CheckFusionMaterial 配合 gc 函数限制墓地数量
		and c:CheckFusionMaterial(m,nil,chkf)
end

function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp)
		local mg1=mg:Filter(s.mfilter1,nil,e) -- 手卡/场上可解放
		
		-- 检查普通融合
		local res=Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if res then return true end
		
		-- 检查本家融合 (允许墓地)
		local mg2=Duel.GetMatchingGroup(s.mfilter2,tp,LOCATION_GRAVE,0,nil,e) -- 墓地可除外
		mg2:Merge(mg1)
		local old_chk=aux.FCheckAdditional
		aux.FCheckAdditional=s.fcheck
		res=Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf)
		aux.FCheckAdditional=old_chk
		
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end

-- 限制墓地素材最多1张
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end

function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp)
	local mg1=mg:Filter(s.mfilter1,nil,e) -- 手卡/场上
	local mg2=Duel.GetMatchingGroup(s.mfilter2,tp,LOCATION_GRAVE,0,nil,e) -- 墓地
	
	local sg1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	
	-- 为了本家融合，合并墓地素材
	local mg_mix=mg1:Clone()
	mg_mix:Merge(mg2)
	
	-- 应用限制：墓地最多1张
	local old_chk=aux.FCheckAdditional
	aux.FCheckAdditional=s.fcheck
	local sg2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg_mix,nil,chkf)
	aux.FCheckAdditional=old_chk
	
	-- 合并所有可融合怪兽
	sg1:Merge(sg2)
	
	if #sg1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		
		-- 如果选的是本家怪兽 (可以使用墓地)
		if sg2:IsContains(tc) then
			-- 再次应用限制
			aux.FCheckAdditional=s.fcheck
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg_mix,nil,chkf)
			aux.FCheckAdditional=old_chk
			
			tc:SetMaterial(mat1)
			
			-- 分离区域进行处理
			local mat_gy=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE) -- 墓地素材 -> 除外
			local mat_rel=mat1:Filter(aux.NOT(Card.IsLocation),nil,LOCATION_GRAVE) -- 手卡/场上 -> 解放
			
			if #mat_rel>0 then Duel.Release(mat_rel,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION) end
			if #mat_gy>0 then Duel.Remove(mat_gy,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION) end
		else
			-- 如果选的是普通怪兽 (仅手卡/场上)
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat2)
			Duel.Release(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		end
		
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end