local s,id=GetID()
function s.initial_effect(c)
	-- 记述卡名
	aux.AddCodeList(c,11772015,1172015)

	-- ①：从以下效果选择1个发动。自己场上有「11772015」存在的场合，可以再选择1个。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	-- ②：这张卡被效果从手卡丢弃的场合才能发动。这张卡加入手卡。那之后，可以让自己墓地·除外状态的至多5张卡回到卡组。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1) 
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

-- ① 效果逻辑：获取对方场上最低攻击力
function s.get_min_atk(tp)
	local opp_g = Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #opp_g == 0 then return -1 end
	local min_atk = 9999999
	for tc in aux.Next(opp_g) do
		local atk = tc:GetAttack()
		if atk < min_atk then min_atk = atk end
	end
	return min_atk
end

-- 各选项的过滤条件
function s.chkfilter(c)
	return c:IsFaceup() and c:IsCode(11772015)
end
function s.spfilter(c,e,tp)
	return c:IsCode(11772015) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.dcfilter(c,min_atk)
	-- 丢弃的怪兽其攻击力必须大于或等于对方场上的最低攻击力（才能保证“以下”时至少卷入1只）
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable(REASON_EFFECT) and c:GetAttack() >= min_atk
end
function s.desfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<=atk
end
function s.epsetfilter(c)
	return c:IsCode(id) and c:IsSSetable()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 获取最低攻击力以判定选项 2
	local min_atk = s.get_min_atk(tp)
	
	local b1 = Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	local b2 = (min_atk >= 0) and Duel.IsExistingMatchingCard(s.dcfilter,tp,LOCATION_HAND,0,1,nil,min_atk)
	local b3 = true

	if chk==0 then return b1 or b2 or b3 end

	local max = Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_ONFIELD,0,1,nil) and 2 or 1
	local sel = 0
	
	for i=1, max do
		local ops = {}
		local opval = {}
		local off = 1
		
		if b1 and (sel&1)==0 then 
			ops[off] = aux.Stringid(id,0) 
			opval[off] = 1
			off = off+1
		end
		if b2 and (sel&2)==0 then 
			ops[off] = aux.Stringid(id,1) 
			opval[off] = 2
			off = off+1
		end
		if b3 and (sel&4)==0 then 
			ops[off] = aux.Stringid(id,2) 
			opval[off] = 4
			off = off+1
		end
		
		if off==1 then break end
		
		if i==2 then
			ops[off] = aux.Stringid(id,3) 
			opval[off] = 8
			off = off+1
		end
		
		local op = Duel.SelectOption(tp, table.unpack(ops)) + 1
		local picked = opval[op]
		if picked == 8 then break end
		sel = sel | picked
	end
	e:SetLabel(sel)
	
	if (sel&1)~=0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end
	if (sel&2)~=0 then
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel = e:GetLabel()
	local resolved = 0
	
	-- 1. 结算特召
	if (sel&1)~=0 then
		if resolved>0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1 = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #g1>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
		resolved = 1
	end
	
	-- 2. 结算丢弃与破坏
	if (sel&2)~=0 then
		if resolved>0 then Duel.BreakEffect() end
		-- 处理时再次获取最低攻击力，防止连锁导致场面变化
		local current_min_atk = s.get_min_atk(tp)
		if current_min_atk >= 0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			-- 强行过滤：只能选攻击力大于或等于最低攻击力的怪兽
			local g2 = Duel.SelectMatchingCard(tp,s.dcfilter,tp,LOCATION_HAND,0,1,1,nil,current_min_atk)
			if #g2>0 and Duel.SendtoGrave(g2,REASON_EFFECT+REASON_DISCARD)~=0 then
				local tc = g2:GetFirst()
				local atk = tc:GetAttack()
				if atk>=0 then
					local dg = Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,atk)
					if #dg>0 then
						Duel.Destroy(dg,REASON_EFFECT)
					end
				end
			end
		end
		resolved = 1
	end
	
	-- 3. 结算注册结束阶段的盖放
	if (sel&4)~=0 then
		if resolved>0 then Duel.BreakEffect() end
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(s.epcon)
		e1:SetOperation(s.epop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

-- 结束阶段盖放处理逻辑
function s.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.epsetfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function s.epop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.epsetfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end

-- ② 效果逻辑：因效果丢弃回收并洗回卡组
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) and (r&REASON_EFFECT)~=0 and (r&REASON_DISCARD)~=0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,5,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end