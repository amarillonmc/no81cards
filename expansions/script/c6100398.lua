--锋焰显征-白龙
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	--①：加攻 + 规则特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--②：降攻 + 条件无效
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.atkcon)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)

	--③：代破 (场上的卡被效果破坏的场合，代破装备魔法)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
end

-- === 效果① ===
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end

-- 定义规则特召的类型列表
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

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sprule_filter,tp,0xff,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		-- 攻击力上升1000
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		
		-- 规则特召龙族怪兽
		if Duel.IsExistingMatchingCard(s.sprule_filter,tp,0xff,0,1,nil) then
			
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

-- === 效果② ===
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttack()>0 
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,0,1-tp,LOCATION_MZONE)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	local val=math.floor(c:GetAttack()/2)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	
	local zero_check=false -- 标记是否有怪兽变成0
	for tc in aux.Next(g) do
		local pre_atk=tc:GetAttack()
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		
		-- 检查：原本攻击力>0 且 现在的攻击力==0 (被此效果变成0)
		if pre_atk>0 and tc:GetAttack()==0 then
			zero_check=true
		end
	end
	
	-- 变成0的场合，可以再把那个效果无效并破坏
	-- 注意：这里的re是触发此连锁的效果
	if zero_check and Duel.IsChainDisablable(ev) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			if Duel.NegateActivation(ev) then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end

-- === 效果③：代破 ===
function s.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) 
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

-- 寻找可以作为代价破坏的“其他卡”
-- 必须是自己场上的卡，且不能是本次“将要被破坏的卡(eg)”中的任何一张
function s.desfilter(c,e,tp,eg)
	return c:IsControler(tp) and c:IsDestructable(e) 
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED) 
		and not eg:IsContains(c)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 检查是否有“场上的卡”要被效果破坏
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,e,tp,eg) end
	
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler(),e,tp,eg)
		Duel.Hint(HINT_CARD,0,id)
		Duel.HintSelection(g)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else
		return false
	end
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end