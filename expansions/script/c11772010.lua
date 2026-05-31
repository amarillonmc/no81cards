local s,id=GetID()
function s.initial_effect(c)
	-- 记述卡名
	aux.AddCodeList(c,11772015)

	-- ①：场上的这张卡每回合只有1次不会被战斗·效果破坏。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(s.indct)
	c:RegisterEffect(e1)

	-- ②：自己的主要阶段才能发动。从自己手卡选1张其他卡丢弃，这张卡从手卡特殊召唤。那之后，可以把对方场上1只怪兽破坏。自己场上有「11772015」存在的场合，对方场上1张卡除外。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	-- ③：这张卡被效果从手卡丢弃的场合才能发动。这张卡特殊召唤。
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.spcon2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)

	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end

-- ① 效果逻辑：代破判定
function s.indct(e,re,r,rp)
	if (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0 then
		return 1
	else
		return 0
	end
end

-- ② 效果逻辑：丢弃、特召、可选破坏与除外
function s.cfilter(c)
	return c:IsDiscardable(REASON_EFFECT)
end
function s.chkfilter(c)
	return c:IsFaceup() and c:IsCode(11772015)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		-- 基础条件：场上有空位、手卡能丢弃、自身能特召。
		-- 【修改】移除了防止空发的复杂判定，因为后续效果现在是可选的
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	-- 【修改】破坏和除外因为是可选的，数量可以标记为 0
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_ONFIELD)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 1. 效果丢弃
	if Duel.DiscardHand(tp,s.cfilter,1,1,REASON_EFFECT+REASON_DISCARD,c)>0 then
		-- 2. 特殊召唤
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			
			-- 判断当前是否满足破坏条件（对方场上有怪兽）
			local can_destroy = Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
			
			-- 判断当前是否满足除外条件（自己有11772015，且对方场上有能除外的卡）
			local can_banish = Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_ONFIELD,0,1,nil) 
							   and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,tp)
			
			-- 3. 核心改动：把破坏和除外打包为一个追加效果询问
			-- 只要能破坏，或者能除外，就可以提示玩家是否发动（提示文本用索引 2）
			if (can_destroy or can_banish) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				local did_destroy = false
				
				-- ① 如果能破坏，执行破坏
				if can_destroy then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
					local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
					if #g1>0 then
						Duel.HintSelection(g1)
						if Duel.Destroy(g1,REASON_EFFECT)~=0 then
							did_destroy = true
						end
					end
				end
				
				-- ② 破坏结束后，重新判定场上是否有 11772015 以及对方是否有卡可除外
				if Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_ONFIELD,0,1,nil) then
					local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,tp)
					if #g2>0 then
						-- 如果刚才成功破坏了怪兽，中间需要插入时点阻断
						if did_destroy then Duel.BreakEffect() end
						
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
						local sg=g2:Select(tp,1,1,nil)
						Duel.HintSelection(sg)
						Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
					end
				end
			end
		end
	end
end

-- ③ 效果逻辑：因效果从手卡丢弃场合特召
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) and (r&REASON_EFFECT)~=0 and (r&REASON_DISCARD)~=0
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end