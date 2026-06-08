-- 卡片名称（这里请修改为你想要的卡号）
local s,id=GetID()
function s.initial_effect(c)
	-- 同调召唤条件：调整+调整以外的怪兽1只以上
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	
	-- ①：这张卡同调召唤的场合才能发动。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	
	-- ②：场上有其他怪兽特殊召唤的场合才能发动。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.e2con)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end

-- ==========================================
-- 效果①：同调召唤场合苏生风属性怪兽并抽卡
-- ==========================================
function s.e1con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.spfilter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsAttribute(ATTRIBUTE_WIND) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tc=g:GetFirst()
		-- 这个效果把调整怪兽特殊召唤的场合，可以抽1张卡
		if tc:IsType(TYPE_TUNER) and Duel.IsPlayerCanDraw(tp,1) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then -- aux.Stringid(id,2) 对应提示文本："是否抽1张卡？"
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
	-- 这个效果发动后，直到下个回合结束自己不能把风属性怪兽以外的从额外卡组特殊召唤的怪兽的效果发动。
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2) -- 重置时间：直到下个回合结束
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	local tc=re:GetHandler()
	-- 判定条件：在怪兽区域（场上），是从额外卡组特殊召唤的，且不是风属性的怪兽效果
	return tc:IsLocation(LOCATION_MZONE) and tc:IsSummonLocation(LOCATION_EXTRA) 
		and not tc:IsAttribute(ATTRIBUTE_WIND) and re:IsActiveType(TYPE_MONSTER)
end

-- ==========================================
-- 效果②：有其他怪兽特召时，进行同调召唤
-- ==========================================
function s.e2con(e,tp,eg,ep,ev,re,r,rp)
	-- 场上有「其他怪兽」特殊召唤的场合（排除这张卡自己）
	return eg:IsExists(aux.TRUE,1,e:GetHandler())
end
function s.scfilter(c,mg)
	-- 必须是风属性，且能够用自己场上的怪兽进行同调召唤
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSynchroSummonable(nil,mg)
end
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(s.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end