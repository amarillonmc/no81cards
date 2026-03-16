local s,id=GetID()

function s.initial_effect(c)
	-- ①：发动效果（以墓地最多2只本家为对象，无效特召，之后可超量召唤）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id) -- 这个卡名的①效果1回合只能使用1次
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- ②：墓地代破（保护场上的「特诺奇」怪兽）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end

-- ==================== ①效果：墓地复活与二速超量 ====================
function s.spfilter(c,e,tp)
	-- 墓地的「特诺奇」怪兽
	return c:IsSetCard(0x5328) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	
	-- 获取当前的空余格子
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	-- 如果受到「青眼精灵龙」等卡片限制（不能同时特召2只怪兽），则最多只能选1只
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	
	-- 最多2只，且不能超过当前空余格子
	local max=math.min(ft,2)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	-- 选取 1 到 max 只怪兽作为对象
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,max,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end

function s.xyzfilter(c,mg)
	-- 寻找额外卡组中能使用场上现有怪兽(mg)进行超量召唤的怪兽
	return c:IsXyzSummonable(nil,mg)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	
	-- 再次确认格子是否足够，以及是否触碰了同时特召的禁忌
	if #g==0 or (#g>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) or #g>ft then return end
	
	-- 步骤1：无效并特殊召唤
	local tc=g:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			-- 效果无效化（基本状态）
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			-- 效果无效化（发动的效果）
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete() -- 统一完成特殊召唤
	
	-- 步骤2：那之后，可以进行超量召唤
	-- 获取当前自己场上所有表侧表示的怪兽作为潜在素材
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	-- 寻找可以被超量召唤的怪兽
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	
	if #xyzg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then -- 需在cdb填入 "[1] 是否进行超量召唤？"
		Duel.BreakEffect() -- "那之后"代表这是两步独立的动作，插入效果断点
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		if xyz then
			-- 执行超量召唤（标准调用，无须强制指定刚才特召的怪兽，只要是场上的都行）
			Duel.XyzSummon(tp,xyz,nil,mg)
		end
	end
end

-- ==================== ②效果：墓地代破 ====================
function s.repfilter(c,tp)
	-- 必须是自己场上、表侧表示的「特诺奇」怪兽，且即将被战破或效破
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x5328) and not c:IsReason(REASON_REPLACE)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 判断：这张卡能否被除外，且场上是否有符合代破条件的怪兽
	if chk==0 then return c:IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,2)) then -- 需在cdb填入 "[2] 是否把墓地的这张卡除外作为代替？"
		return true
	end
	return false
end
function s.repval(e,c)
	-- 对满足条件的对象应用代破
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	-- 代替破坏的代价：将墓地的这张卡除外
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end