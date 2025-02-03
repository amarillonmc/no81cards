-- 天下任龙游 (60000210)
local s,id=GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,60000196)  -- 蒲牢·华钟
	
	-- 效果1：发动时特招
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 效果2：召唤/特殊召唤对应效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

-- 效果1特殊召唤
function s.spfilter(c,e,tp)
	return c:IsCode(60000196) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
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
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end

-- 效果2相关函数
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) -- 仅检查对方召唤
end

function s.pulao_filter(c)
	return c:IsCode(60000196) and c:IsFaceup()
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	-- 给召唤的怪兽添加免疫
	local g=eg:Filter(Card.IsSummonPlayer,nil,1-tp)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	
	-- 后续处理需要场上有蒲牢
	local pulao=Duel.GetMatchingGroup(s.pulao_filter,tp,LOCATION_MZONE,0,nil)
	if #pulao==0 then return end
	
	-- 检查可放置指示物的蒲牢（未满4且未被无效）
	local canPlace=false
	for tc in aux.Next(pulao) do
		if tc:GetCounter(0x62b)<4 and not tc:IsHasEffect(EFFECT_DISABLE) then
			canPlace=true
			break
		end
	end
	
	-- 选择放置指示物
	if canPlace and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local g2=Duel.SelectMatchingCard(tp,s.place_filter,tp,LOCATION_MZONE,0,1,1,nil)
		if #g2>0 then
			g2:GetFirst():AddCounter(0x62b,1)
		end
	else
		-- 检查所有蒲牢是否满足条件（满4或被无效）
		local allValid=true
		for tc in aux.Next(pulao) do
			local isNegated=tc:IsHasEffect(EFFECT_DISABLE) or tc:IsHasEffect(EFFECT_DISABLE_EFFECT)
			if not (tc:GetCounter(0x62b)>=4 or isNegated) then
				allValid=false
				break
			end
		end
		
		if allValid then
			local drawNum=Duel.GetMatchingGroupCount(s.pulao_filter,tp,LOCATION_MZONE,0,nil)
			Duel.Draw(tp,drawNum,REASON_EFFECT)
		end
	end
end

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.place_filter(c)
	return s.pulao_filter(c) and c:GetCounter(0x62b)<4 and not c:IsHasEffect(EFFECT_DISABLE)
end