--朦雨的织者·薇尔薇特
local s,id,o=GetID()
function s.initial_effect(c)
	--①：特召自身
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetCondition(aux.NOT(s.spcon))
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.spcon)
	c:RegisterEffect(e3)
	--②：二选一效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.effcost)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.exfilter(c)
	return c:IsSetCard(0x613) and c:IsSummonLocation(LOCATION_EXTRA)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.thfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost()) and c:IsFaceup()
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- === 效果② ===
function s.costfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end

function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

-- 选项1：卡组检索/特召
function s.op1filter(c,e,tp)
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) 
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end

-- 选项2：送墓特召额外
function s.op2costfilter(c)
	return c:IsSetCard(0x613) and c:IsAbleToGrave()
end
function s.op2spfilter(c,e,tp)
	return c:IsSetCard(0x613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 检查选项1可行性
	local b1=Duel.IsExistingMatchingCard(s.op1filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	-- 检查选项2可行性
	-- 需送墓包含自己在内的2只怪兽。因此需要场上有另一只可送墓的「朦雨」怪兽。
	local b2=Duel.IsExistingMatchingCard(s.op2costfilter,tp,LOCATION_MZONE,0,1,c) 
		and Duel.IsExistingMatchingCard(s.op2spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	end
	e:SetLabel(op)
	
	if op==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	
	if op==0 then
		-- 执行选项1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.op1filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			local b_th=tc:IsAbleToHand()
			local b_sp=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			local opt=0
			if b_th and b_sp then
				opt=Duel.SelectOption(tp,1190,1152) -- 1190:加手, 1152:特召
			elseif b_th then
				opt=0
			else
				opt=1
			end
			
			if opt==0 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		-- 执行选项2
		-- 必须包含这张卡
		if not c:IsRelateToEffect(e) then return end
		local g=Duel.GetMatchingGroup(s.op2costfilter,tp,LOCATION_MZONE,0,c)
		if #g<1 then return end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		sg:AddCard(c)
		
		if Duel.SendtoGrave(sg,REASON_EFFECT)==2 then -- 确认2张都送去墓地了
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local exg=Duel.SelectMatchingCard(tp,s.op2spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if #exg>0 then
				Duel.SpecialSummon(exg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end