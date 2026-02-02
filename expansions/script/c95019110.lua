--影牙结合
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：战斗阶段送墓并特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 发动条件：战斗阶段
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end

-- 目标设定
function s.tgfilter(c)
	return c:IsSetCard(0xc96c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:GetLevel()<=3
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0xc96c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查场上是否有2只影牙怪兽可以送墓
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_MZONE,0,nil)
		if #g<2 then return false end
		
		-- 检查额外卡组是否有影牙怪兽可以特殊召唤
		return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

-- 效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 选择2只影牙怪兽送去墓地
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE,0,2,2,nil)
	if #g~=2 then return end
	
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		-- 检查送墓的怪兽是否到达墓地
		local ct=0
		for tc in aux.Next(g) do
			if tc:IsLocation(LOCATION_GRAVE) then ct=ct+1 end
		end
		if ct==2 then
			-- 从额外卡组特殊召唤1只影牙怪兽
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if #sg>0 then
				local sc=sg:GetFirst()
				if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
					-- 赋予特殊召唤的怪兽一个效果
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetDescription(aux.Stringid(id,1))
					e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
					e1:SetType(EFFECT_TYPE_QUICK_O)
					e1:SetRange(LOCATION_MZONE)
					e1:SetCode(EVENT_FREE_CHAIN)
					e1:SetHintTiming(TIMING_BATTLE_PHASE)
					e1:SetCondition(s.effcon)
					e1:SetCost(s.effcost)
					e1:SetTarget(s.efftg)
					e1:SetOperation(s.effop)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e1)
				end
			end
		end
	end
end

-- 赋予效果的发动条件：战斗阶段
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end

-- 赋予效果的代价：解放自身
function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

-- 赋予效果的目标：墓地中2只3星以下影牙怪兽
function s.efffilter(c,e,tp)
	return c:IsSetCard(0xc96c) and c:IsType(TYPE_MONSTER) and c:GetLevel()<=3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.efffilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		return #g>=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end

-- 赋予效果的操作：特殊召唤并添加回合限制
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	-- 特殊召唤2只3星以下影牙怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.efffilter,tp,LOCATION_GRAVE,0,1,2,nil,e,tp)
	if #g==2 then
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
		
		-- 添加回合限制：不能从墓地把暗属性以外的怪兽特殊召唤
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

-- 特殊召唤限制：暗属性以外的怪兽不能从墓地特殊召唤
function s.splimit(e,c)
	return c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) and not c:IsAttribute(ATTRIBUTE_DARK)
end