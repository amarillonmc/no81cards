--落日残响·奈美·Sunset
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,6100316,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,true,true)

	--①：额外卡组解放加攻
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)

	--②：自身抗性与限制
	--不能攻击宣言
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--不会成为攻击对象
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	--不会成为对方的效果的对象
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)

	--③：战斗阶段烧血+解场
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_RELEASE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END)
	e5:SetCondition(s.rmcon)
	e5:SetCost(s.rmcost)
	e5:SetTarget(s.rmtg)
	e5:SetOperation(s.rmop)
	c:RegisterEffect(e5)
end

-- === 效果① ===
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.exfilter(c)
	-- 模拟解放：能被送去墓地
	return c:IsSetCard(0x614) and c:IsType(TYPE_FUSION) and c:IsAbleToGrave()
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil) end
	-- 提示信息设为解放，尽管实际操作是送墓
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_EXTRA)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		-- 使用 REASON_RELEASE 标记送墓，视为解放
		if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RELEASE)>0 then
			local atk=tc:GetTextAttack()
			if atk>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
			end
		end
	end
end

-- === 效果③ ===
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end

function s.costfilter(c)
	-- 属于「落日残响」且可解放
	-- 场所：公开的手卡 OR 表侧的场上卡
	return c:IsSetCard(0x614) and c:IsReleasable()
		and ((c:IsLocation(LOCATION_HAND) and c:IsPublic()) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()))
end

function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end

function s.rmfilter(c)
	return c:IsFaceup()
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,1-tp,LOCATION_MZONE)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		-- 计算伤害
		local my_atk = 0
		if c:IsRelateToEffect(e) and c:IsFaceup() then 
			my_atk = c:GetAttack() 
		end
		
		local opp_val = tc:GetAttack()
		-- 如果不是连接怪兽，取攻守较低值；如果是连接，直接取攻击力
		if not tc:IsType(TYPE_LINK) then
			local def = tc:GetDefense()
			if def < opp_val then 
				opp_val = def 
			end
		end
		
		local damage = math.abs(my_atk - opp_val)
		if damage < 0 then damage= - damage end
		
		-- 造成伤害后解放
		if Duel.Damage(1-tp,damage,REASON_EFFECT)>0 then
			Duel.Release(tc,REASON_EFFECT)
		end
	end
end