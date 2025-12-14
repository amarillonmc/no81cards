--暴雨的刻时
local s,id,o=GetID()
function s.initial_effect(c)
	--①：根据数量适用效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--②：墓地特召+回收
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- === 效果① ===

function s.cntfilter(c)
	return c:IsSetCard(0x613) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK))
end

-- 检查：移动怪兽
function s.mvfilter(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end

-- 检查：堆墓
function s.tgfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

-- 检查：赋予抗性
function s.efffilter(c)
	return c:IsSetCard(0x613) and c:IsFaceup()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.cntfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then
		if ct<1 then return false end
		local b1 = Duel.IsExistingMatchingCard(s.mvfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		local b2 = Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
		local b3 = Duel.IsExistingMatchingCard(s.efffilter,tp,LOCATION_MZONE,0,1,nil)
		
		-- 必须满足所有将要适用的效果条件
		if ct>=1 and not b1 then return false end
		if ct>=2 and not b2 then return false end
		if ct>=3 and not b3 then return false end
		return true
	end
	
	if ct>=2 then Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.cntfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	
	-- ●1只以上：移动
	if ct>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.mvfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			local seq=tc:GetSequence()
			local b1=(seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
			local b2=(seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
			local new_seq=0
			if b1 and b2 then
				local op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3)) -- 向左, 向右 (需在strings.conf定义，或用通用提示)
				if op==0 then new_seq=seq-1 else new_seq=seq+1 end
			elseif b1 then
				new_seq=seq-1
			else
				new_seq=seq+1
			end
			Duel.MoveSequence(tc,new_seq)
		end
	end
	
	-- ●2只以上：堆墓
	if ct>=2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	
	-- ●3只以上：赋予抗性
	if ct>=3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,s.efffilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			-- 发动的效果不会被无效化
			-- 1. 发动不会被无效
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_INACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(s.efilter_val)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			-- 2. 效果不会被无效
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_DISEFFECT)
			tc:RegisterEffect(e2)
			
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4)) -- 抗性提示
		end
	end
end

function s.efilter_val(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end

-- === 效果② ===

function s.spfilter_base(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter_base(chkc) end
	-- 检查连接区是否有位置
	local zone=Duel.GetLinkedZone(tp)
	if chk==0 then
		return zone~=0 
			and Duel.IsExistingTarget(s.spfilter_base,tp,LOCATION_GRAVE,0,2,nil)
			and e:GetHandler():IsAbleToDeck()
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.spfilter_base,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local zone=Duel.GetLinkedZone(tp)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	-- 选1只回卡组
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg2=tg:FilterSelect(tp,s.spfilter_base,1,1,nil)
	tg:Sub(tg2)
	local tc=tg2:GetFirst()
	local tc2=tg:GetFirst()
	if tc and zone~=0 and tg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
			Duel.SendtoDeck(tc2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	
	-- 自身回卡组
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end