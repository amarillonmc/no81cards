-- 魁杓七圣-廉贞玉衡
local s,id=GetID()

function s.initial_effect(c)
	-- ①：战阶二速从手卡·场上解放7星怪兽特召（同连锁最多1次）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN) -- 同一连锁上最多1次
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end

-- ==================== ①效果：战阶特召 ====================
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.cfilter(c,ft,tp)
	-- 可以作为Cost解放的条件：7星、可解放。
	-- 【核心判定】：如果当前怪兽区没有空位(ft<=0)，那么被解放的怪兽必须是你场上的怪兽（从而腾出一个空位）
	return c:IsLevel(7) and c:IsReleasable()  and not c:IsCode(id)
		and (ft>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and c:IsControler(tp)))
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 获取当前的空余怪兽格数量
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,ft,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,ft,tp)
	Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- Cost阶段已经排除了没格子的Bug，这里只需预判能不能被特召
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.thfilter(c)
	-- 卡组检索：本家字段，且不能是同名卡
	return c:IsSetCard(0x3328) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 【关键点】：在它特召下场、位置发生变化前，记录它现在的位置（手卡或墓地）
	local prev_loc=c:GetLocation()
	
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 判定分支：根据之前所在的位置，决定可以触发哪个后续效果
		
		-- 分支A：从手卡特召 -> 检索卡组
		if prev_loc==LOCATION_HAND then
			-- 检查这个“适用”效果是否在一回合内使用过（FlagEffect id+1）
			if Duel.GetFlagEffect(tp,id+1)==0
				and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then -- 需在cdb填入 "[1] 是否从卡组将本家怪兽加入手卡？"
				
				Duel.BreakEffect()
				Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1) -- 记录该效果本回合已适用
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
				if #g>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
			
		-- 分支B：从墓地特召 -> 不取对象攻0+无效
		elseif prev_loc==LOCATION_GRAVE then
			-- 检查这个“适用”效果是否在一回合内使用过（FlagEffect id+2）
			if Duel.GetFlagEffect(tp,id+2)==0
				and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then -- 需在cdb填入 "[2] 是否选对方场上1只怪兽攻击力变成0并无效化？"
				
				Duel.BreakEffect()
				Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1) -- 记录该效果本回合已适用
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
				-- "选"意味着在处理时才指定卡片（非Target效果）
				local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.HintSelection(g)
					-- 1. 攻击力变成0
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetValue(0)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					-- 2. 效果无效
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_EFFECT)
					e3:SetValue(RESET_TURN_SET)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
			end
		end
	end
end