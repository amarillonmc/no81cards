local s,id=GetID()
function s.initial_effect(c)
	-- 添加卡名记述
	aux.AddCodeList(c,11772070)
	
	-- ①：特殊召唤效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	-- ①效果1回合只能使用1次
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- ②：代替破坏效果
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	-- ②效果1回合只能使用1次
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end

-- ==================== ① 效果相关 ====================
function s.cfilter(c)
	-- 过滤出“不满足条件”的怪兽：里侧表示（无等级），或者等级不是5星及以上（包含1-4星、超量、连接怪兽）
	return c:IsFacedown() or not c:IsLevelAbove(5)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	-- 自己场上没有怪兽（数量为0），或者存在的怪兽中没有“不满足条件”的怪兽（即全部是5星以上的怪兽）
	return #g==0 or g:FilterCount(s.cfilter,nil)==0
end
function s.spfilter(c,e,tp)
	return aux.IsCodeListed(c,11772070) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	-- 第一只怪兽特召成功后
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 结算此时场上的怪兽数量，判断对方怪兽是否比自己多
		if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) > Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
			-- 同时需要保证自己场上还有空位且卡组里还有符合条件的怪兽
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
			
			-- 询问是否要再特召1只
			if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				if #sg>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end

-- ==================== ② 效果相关 ====================
function s.repfilter(c,tp)
	-- 必须是自己场上的表侧表示、5星以上的怪兽，且因为战斗或效果被破坏
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) 
		and c:IsLevelAbove(5) and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 判断将要被破坏的卡中是否有符合条件的怪兽，且墓地的此卡能够被除外
	if chk==0 then return c:IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	-- 弹窗提示是否使用代替破坏效果（96 是系统预设的通用“代替提示”文本ID）
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else
		return false
	end
end
function s.repval(e,c)
	-- 返回需要被代破的卡
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	-- 执行代替动作：将墓地的这张卡除外
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end