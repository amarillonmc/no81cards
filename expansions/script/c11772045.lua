local s,id=GetID()
function s.initial_effect(c)
	-- 记述卡名
	aux.AddCodeList(c,11772015)

	-- 这个卡名的卡在1回合只能发动1张。
	-- 注意：EFFECT_COUNT_CODE_OATH 专门用于限制卡片的“发动”次数
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	-- ②：这张卡被效果从手卡丢弃的场合才能发动。这张卡加入手卡。那之后，可以把对方场上1张卡除外。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(3,id+1)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	-- 兼容大宇宙环境，被效果丢弃去除外区也能触发
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

-- ① 效果逻辑：丢弃并除外
function s.cfilter(c)
	return c:IsDiscardable(REASON_EFFECT)
end
function s.chkfilter(c)
	return c:IsFaceup() and c:IsCode(11772015)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		-- 发动前提：自己手卡有可以被效果丢弃的卡，且对方场上存在可以被除外的卡
		return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 自己选1张手卡丢弃 (作为效果处理)
	if Duel.DiscardHand(tp,s.cfilter,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		-- 对方场上1张卡除外
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
		
		-- 自己场上有「11772015」存在的场合，有手卡的玩家选自身1张手卡丢弃
		if Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
			local h2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
			if h1>0 or h2>0 then
				Duel.BreakEffect()
				if h1>0 then
					Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
				end
				if h2>0 then
					Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
				end
			end
		end
	end
end

-- ② 效果逻辑：回收并选发除外
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) and (r&REASON_EFFECT)~=0 and (r&REASON_DISCARD)~=0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 这张卡加入手卡
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
		-- 那之后，可以把对方场上1张卡除外
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end