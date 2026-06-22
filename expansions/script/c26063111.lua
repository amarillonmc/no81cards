-- 雷霆魂 寒灾
local m=26063111
local cm=_G["c"..m]
function cm.initial_effect(c)
  c:EnableReviveLimit()
	aux.AddCodeList(c,26053101)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,m)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(cm.reg_ret)
	c:RegisterEffect(e3)
end
function cm.nofilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_THUNDER)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.nofilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thunder_spell_faceup(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsSetCard(0xeae9)
end
-- 辅助函数：判断卡组中的「雷霆」魔法卡
function cm.thunder_spell_in_deck(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0xeae9)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		-- 丢弃手卡是cost，必须可以丢弃
		if not c:IsDiscardable() then return false end
		-- 检查是否需要展示：如果场上有表侧「雷霆」魔法卡，则免展示
		local have_faceup = Duel.IsExistingMatchingCard(cm.thunder_spell_faceup,tp,LOCATION_ONFIELD,0,1,nil)
		if have_faceup then
			return true
		else
			-- 需要从卡组展示3张「雷霆」魔法卡，因此卡组中必须有至少3张
			local g=Duel.GetMatchingGroup(cm.thunder_spell_in_deck,tp,LOCATION_DECK,0,nil)
			return g:GetCount()>=3
		end
	end
	-- 执行cost：丢弃手卡
	if Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)==0 then return false end
	-- 再次检查是否需要展示
	local have_faceup = Duel.IsExistingMatchingCard(cm.thunder_spell_faceup,tp,LOCATION_ONFIELD,0,1,nil)
	if not have_faceup then
		-- 从卡组选出3张「雷霆」魔法卡展示给对方
		local g=Duel.GetMatchingGroup(cm.thunder_spell_in_deck,tp,LOCATION_DECK,0,nil)
		if g:GetCount()<3 then return false end
		-- 由于没有指定选哪3张，这里取前3张（或者可以随机，但通常展示任意3张即可）
		local sg=Duel.SelectMatchingCard(tp,cm.thunder_spell_in_deck,tp,LOCATION_DECK,0,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)  -- 展示后洗切卡组
	end
	return true
end
function cm.opt3filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.opt3filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
-- operation：使选择的怪兽效果无效化（直到回合结束）
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectMatchingCard(tp,cm.opt3filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
		end
end

-- ②目标：检索雷霆永续魔法
function cm.thfilter1(c)
	return c:IsAbleToHand()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function cm.thfilter2(c)
	return c:IsAbleToHand()
end
function cm.reg_ret(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.returnop)
	c:RegisterEffect(e1)
end
function cm.returnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_MZONE,0,nil)
			local tg=g:Filter(Card.IsControler,nil,tp)
			if #tg>0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
			end
		end
	end
end