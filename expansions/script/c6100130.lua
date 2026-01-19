--女神之令-简
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,6100138)
	--全局检查：本回合自己是否召唤·特殊召唤过本家怪兽
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end

	--①：二速特召（本回合满足过条件即可发动）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--②：二速多选一（展示魔法仪式召唤 / 展示陷阱盖怪）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end

--------------------------------------------------------------------------------
-- 全局检查
--------------------------------------------------------------------------------
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0x611) then
			--给召唤该怪兽的玩家注册Flag
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end

--------------------------------------------------------------------------------
-- ①效果
--------------------------------------------------------------------------------

--Condition: 检查Flag是否存在
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end

--Target: 仪式特召自身
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

--Operation: 执行特召
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.CheckLPCost(tp,1000) then
	Duel.PayLPCost(tp,1000)
		c:SetMaterial(nil) --标记为仪式召唤
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
				if c:IsLevelAbove(1) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then --"要让等级上升吗？"
				Duel.BreakEffect()
				--选择上升 1 到 4 星
				local val=Duel.AnnounceNumber(tp,1,2)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(val)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
	end
end

--------------------------------------------------------------------------------
-- ②效果
--------------------------------------------------------------------------------

--检查手卡是否有本家魔法（Cost用）
function s.rvspell(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end

--检查是否能进行仪式召唤（Target check用）
function s.ritcheck(c,e,tp)
	if not (c:IsSetCard(0x611) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) then return false end
	local lv=c:GetLevel()
	--获取玩家可用的仪式素材（手卡+场上）
	local mg=Duel.GetRitualMaterial(tp)
	--如果待召唤怪兽在手卡，需要将其从素材列表中移除
	if c:IsLocation(LOCATION_HAND) then mg:RemoveCard(c) end
	--检查是否存在满足等级合计的素材组合
	return mg:CheckWithSumGreater(Card.GetRitualLevel,lv,c)
end

--检查手卡是否有本家陷阱（Cost用）
function s.rvtrap(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_TRAP) and not c:IsPublic()
end

--检查是否有能变里侧的对方怪兽
function s.posfilter(c)
	return c:IsCanTurnSet()
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	--条件1：有魔法展示 + 能从手/卡组仪式召唤
	local b1 = Duel.IsExistingMatchingCard(s.rvspell,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(s.ritcheck,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	
	--条件2：有陷阱展示 + 能盖对方怪兽
	local b2 = Duel.IsExistingMatchingCard(s.rvtrap,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(s.posfilter,tp,0,LOCATION_MZONE,1,nil)
	
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
		--盖放通常不设Category，除非涉及墓地
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
	
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.rvspell,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		--选择要召唤的仪式怪兽
		local tg=Duel.SelectMatchingCard(tp,s.ritcheck,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=tg:GetFirst()
		if tc then
			local lv=tc:GetLevel()
			local mg=Duel.GetRitualMaterial(tp)
			if tc:IsLocation(LOCATION_HAND) then mg:RemoveCard(tc) end
			
			--选择并解放素材
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,lv,tc)
			tc:SetMaterial(mat)
			--注意：这里使用通用的Release，而非ReleaseRitualMaterial，因为不是通过仪式魔法卡发动
			Duel.Release(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
			
			--特殊召唤
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end 
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.rvtrap,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,s.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	end
end