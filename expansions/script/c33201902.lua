local s,id=GetID()

function s.initial_effect(c)
	-- ①：以自己墓地1只本家怪兽为对象，手卡自身与对象怪兽一同特召，并可变6星
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- ②：因战斗·效果以外送去墓地的场合，选对方场上1只怪兽攻0+无效化
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+10000) -- 这个卡名的②效果1回合只能使用1次
	e2:SetCondition(s.gycon)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end

-- ==================== ①效果：墓地复活与变星 ====================
function s.spfilter(c,e,tp)
	-- 墓地的对象必须是「特诺奇」怪兽且能被特殊召唤
	return c:IsSetCard(0x5328) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	
	-- 判断：由于要特召两只怪兽，需要空余格子大于1，且不能受到「青眼精灵龙」等卡片（禁止同时特召2只怪兽）的影响
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:AddCard(c) -- 将自身也加入操作信息中
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	-- 必须保证两张卡都在有效区域，且没有出现中途占满格子的问题
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	
	local g=Group.FromCards(c,tc)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 特召成功后，“那之后”——判断要不要让这张卡的星级变成6星
		-- 需要保证这张卡依然在场上且表侧表示
		if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(6)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) -- 星级变更直到离场或被无效
			c:RegisterEffect(e1)
		end
	end
end

-- ==================== ②效果：攻0并无效化 ====================
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 必须是因战斗·效果以外送去墓地
	return not c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_EFFECT)
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 由于是“选”，因此发动时不取对象，只预判对方场上有没有表侧表示的怪兽即可
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g) -- 在界面上给被选中的卡片闪烁提示
		local c=e:GetHandler()
		
		-- 1. 攻击力变成0（直到回合结束时）
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		
		-- 2. 效果无效化（直到回合结束时）
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end