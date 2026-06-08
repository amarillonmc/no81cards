-- 自定义卡片 (Custom Card)
local s,id,o=GetID()
function s.initial_effect(c)
	-- 同调召唤条件：调整 + 调整以外的怪兽1只
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)

	-- ①：素材检查
-- 先定义 ①：检索/特召触发效果 (e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id+1)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	-- 再定义 ①：素材检查效果 (e0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	e0:SetLabelObject(e1) -- 【关键】：将 e1 设定为 e0 的 LabelObject
	c:RegisterEffect(e0)

	-- ②：自己·对方的回合才能发动。这张卡的等级下降最多3星。那之后，可以把自己的1张手卡持续公开。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+2)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)

	-- ③：用这张卡作为同调素材同调召唤的怪兽当作调整使用，不会成为效果的对象，不会被效果破坏。
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(s.e3con)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
end

-- ==============================================
-- ① 效果逻辑：素材检查与检索/特召
-- ==============================================
function s.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) and c:IsDefense(1300)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(s.matfilter,1,nil) then
		e:GetLabelObject():SetLabel(1) -- 如果满足条件，直接给 e1 贴上 Label = 1
	else
		e:GetLabelObject():SetLabel(0) -- 否则重置为 0（防止同名卡互相干扰）
	end
end

function s.e1con(e,tp,eg,ep,ev,re,r,rp)
	-- 判断条件改为检查自身的 Label
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function s.filter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) and c:IsDefense(1300)
		and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,1190,1152) -- 1190: 加入手卡, 1152: 特殊召唤
		elseif b1 then
			op=0
		else
			op=1
		end
		
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

-- ==============================================
-- ② 效果逻辑：降星与持续公开
-- ==============================================
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLevelAbove(2) end
	local max_drop = math.min(3, c:GetLevel() - 1)
	local t = {}
	for i=1, max_drop do
		table.insert(t, i)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(lv)
end
function s.revfilter(c)
	return not c:IsPublic()
end
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		-- 降低等级
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		
		-- 那之后可以公开手卡
		local hg=Duel.GetMatchingGroup(s.revfilter,tp,LOCATION_HAND,0,nil)
		if #hg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local rg=hg:Select(tp,1,1,nil)
			local rc=rg:GetFirst()
			if rc then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_PUBLIC)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e2)
			end
		end
	end
end

-- ==============================================
-- ③ 效果逻辑：作为同调素材赋予抗性和调整属性
-- ==============================================
function s.e3con(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function s.e3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sync=c:GetReasonCard()
	
	-- 当作调整使用
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_TUNER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sync:RegisterEffect(e1)
	
	-- 不会成为效果的对象
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(1)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetDescription(aux.Stringid(id,4)) -- “不会成为效果对象”文本提示
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	sync:RegisterEffect(e2)
	
	-- 不会被效果破坏
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetDescription(aux.Stringid(id,5)) -- “不会被效果破坏”文本提示
	sync:RegisterEffect(e3)
end