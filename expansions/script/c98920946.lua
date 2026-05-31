--乒乓球小爱神
local s,id=GetID()
function s.initial_effect(c)
	--①：特召 + 变等级
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	--②：等级以下的对方怪兽不能攻击
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.atktg)
	c:RegisterEffect(e2)
end

-- 过滤条件：场上表侧表示、有等级、且当前等级不等于原本等级的怪兽
function s.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:GetLevel()~=c:GetOriginalLevel()
end

-- ①的效果：发动准备
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

-- ①的效果：处理
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	
	-- 1. 计算等级差值（必须在等级变回原本前计算）
	local diff=math.abs(tc:GetLevel()-tc:GetOriginalLevel())
	
	-- 2. 将目标怪兽等级变回原本等级
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(tc:GetOriginalLevel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	
	-- 3. 特殊召唤这张卡
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 那之后：可以选择让这张卡的等级上升或下降那个差值
		if diff>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			
			-- 判断是否可以下降（等级不能降到1以下）
			local can_dec = c:GetLevel() > diff
			local op=0
			if can_dec then
				-- 可以上升或下降
				op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3)) -- 0:上升, 1:下降
			else
				-- 只能选择上升
				op=Duel.SelectOption(tp,aux.Stringid(id,2)) -- 0:上升
			end
			
			local val=diff
			if op==1 then
				val=-diff
			end
			
			-- 改变自身等级
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_LEVEL)
			e2:SetValue(val)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
end

-- ②的效果：限制攻击目标
function s.atktg(e,c)
	local hc=e:GetHandler()
	-- 对方怪兽必须持有等级，且该等级小于或等于这张卡的当前等级
	return c:IsLevelAbove(1) and hc:IsLevelAbove(1) and c:GetLevel()<=hc:GetLevel()
end