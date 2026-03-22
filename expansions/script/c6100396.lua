--白龙云影
local s,id,o=GetID()
function s.initial_effect(c)

	--①：造Token + 规则特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.tkcost)
	e1:SetTarget(s.tktg)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)

	--②：结束阶段回收
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- === 效果①逻辑 ===
function s.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLocation(LOCATION_EXTRA)
end

function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPE_TOKEN+TYPE_MONSTER+TYPE_TUNER,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT) end
	
	-- 宣言1～6的任意等级
	local lv=Duel.AnnounceLevel(tp,1,6)
	e:SetLabel(lv)
	
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end

-- 定义需要检查的特殊召唤类型列表
-- 0 代表通常的规则特召（如电子龙、开辟等）
local SUMMON_TYPES_TABLE = {0, SUMMON_TYPE_FUSION, SUMMON_TYPE_SYNCHRO, SUMMON_TYPE_XYZ, SUMMON_TYPE_LINK, SUMMON_TYPE_SPECIAL, SUMMON_VALUE_SELF}

function s.sprule_filter(c)
	-- 必须是龙族
	if not c:IsRace(RACE_DRAGON) then return false end
	-- 检查是否满足某种规则特召条件
	for _,sumtype in pairs(SUMMON_TYPES_TABLE) do
		if c:IsSpecialSummonable(sumtype) then return true end
	end
	return false
end

function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	local token=Duel.CreateToken(tp,id+1)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
		local lv=e:GetLabel()
		-- 修改Token数据
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(id,2)) -- "只能最多1次特召不持有等级的额外卡组怪兽"
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	
	-- 2. 计数器：监听特召成功事件，若匹配则记录已执行过1次
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(s.checkop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		-- 那之后，可以用自身的方法进行1只龙族怪兽的特殊召唤
		-- 0xff 代表所有区域 (手卡、墓地、额外等)，IsSpecialSummonable会自动检查合法位置
		if Duel.IsExistingMatchingCard(s.sprule_filter,tp,0xff,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			-- 选择要特召的怪兽
			local g=Duel.SelectMatchingCard(tp,s.sprule_filter,tp,0xff,0,1,1,nil)
			local sc=g:GetFirst()
			if sc then
				-- 执行特召
				for _,sumtype in pairs(SUMMON_TYPES_TABLE) do
					if sc:IsSpecialSummonable(sumtype) then
						Duel.SpecialSummonRule(tp,sc,sumtype)
						break
					end
				end
			end
		end
	end
end

-- === 效果②逻辑 ===

function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsLevelAbove(0) and c:IsLocation(LOCATION_EXTRA) and Duel.GetFlagEffect(sump,id+200)>2
end

-- 自肃计数监听
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		-- Xyz与Link怪兽没有Level，且判定来源为额外卡组
		if tc:IsSummonPlayer(tp) and not tc:IsLevelAbove(0) and tc:IsSummonLocation(LOCATION_EXTRA) then
			Duel.RegisterFlagEffect(tp,id+200,RESET_PHASE+PHASE_END,0,1)
			break
		end
	end
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	-- 若自己场上有龙族同调怪兽存在
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end