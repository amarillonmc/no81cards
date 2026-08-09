--捕梦的淑女 斯特帕蕾娅
local s,id,o=GetID()
function s.initial_effect(c)
	--①：解放自身选卡检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	
	--②：除外自身及符合条件的怪兽，结束阶段苏生
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

function s.thfilter(c,attr,lv,race)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(attr) and c:IsLevel(lv) and not c:IsRace(race) and c:IsAbleToHand()
end

function s.selfilter(c,tp)
	if not c:IsType(TYPE_MONSTER) or not c:IsLevelAbove(1) then return false end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
	return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),c:GetLevel(),c:GetRace())
end

function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 需要保证解放自身之后，手卡和双方场上依旧有符合选择条件的其它怪兽
	if chk==0 then return Duel.IsExistingMatchingCard(s.selfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,c,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	-- 选自己手卡以及双方场上1张怪兽卡 (不取对象)
	local g=Duel.SelectMatchingCard(tp,s.selfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.HintSelection(g)
		end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttribute(),tc:GetLevel(),tc:GetRace())
		if #thg>0 then
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		end
	end
end


-- === 效果② ===
function s.rmfilter(c,sc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and (c:IsRace(sc:GetRace()) or c:IsAttribute(sc:GetAttribute()) or (c:IsLevelAbove(1) and sc:IsLevelAbove(1) and c:GetLevel()==sc:GetLevel()))
end

function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,1,c,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,1,1,c,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	local fid=c:GetFieldID()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
	e:SetLabel(fid)
end

function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local c=e:GetHandler()
	
	-- 挂载：这个回合的结束阶段，特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetOperation(s.spop3)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end


-- === 结束阶段延迟触发 ===
function s.spfilter(c,e,tp,fid)
	return Duel.GetLocationCount(p,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end

function s.spop3(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,e,tp,fid)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tc:GetOwner(),false,false,POS_FACEUP_DEFENSE)
		end
	end
end