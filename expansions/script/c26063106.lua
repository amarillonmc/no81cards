-- 雷霆魂 幻彩
local s,id=GetID()
function s.initial_effect(c)
  c:EnableReviveLimit()
	aux.AddCodeList(c,26053101)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.con1)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	-- ②：特殊召唤时检索「雷霆」永续魔法
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.reg_ret)
	c:RegisterEffect(e3)
end
function s.nofilter(c)
    return c:IsFaceup() and not c:IsRace(RACE_THUNDER)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.nofilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.thfilter(c)
	return c:IsSetCard(0xeae9) and c:IsAbleToHand()
end
function s.thunder_spell_faceup(c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsSetCard(0xeae9)
end

-- 辅助函数：判断卡组中的「雷霆」魔法卡
function s.thunder_spell_in_deck(c)
    return c:IsType(TYPE_SPELL) and c:IsSetCard(0xeae9)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        -- 丢弃手卡是cost，必须可以丢弃
        if not c:IsDiscardable() then return false end
        -- 检查是否需要展示：如果场上有表侧「雷霆」魔法卡，则免展示
        local have_faceup = Duel.IsExistingMatchingCard(s.thunder_spell_faceup,tp,LOCATION_ONFIELD,0,1,nil)
        if have_faceup then
            return true
        else
            -- 需要从卡组展示3张「雷霆」魔法卡，因此卡组中必须有至少3张
            local g=Duel.GetMatchingGroup(s.thunder_spell_in_deck,tp,LOCATION_DECK,0,nil)
            return g:GetCount()>=3
        end
    end
    -- 执行cost：丢弃手卡
    if Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)==0 then return false end
    -- 再次检查是否需要展示
    local have_faceup = Duel.IsExistingMatchingCard(s.thunder_spell_faceup,tp,LOCATION_ONFIELD,0,1,nil)
    if not have_faceup then
        -- 从卡组选出3张「雷霆」魔法卡展示给对方
        local g=Duel.GetMatchingGroup(s.thunder_spell_in_deck,tp,LOCATION_DECK,0,nil)
        if g:GetCount()<3 then return false end
        -- 由于没有指定选哪3张，这里取前3张（或者可以随机，但通常展示任意3张即可）
        local sg=Duel.SelectMatchingCard(tp,s.thunder_spell_in_deck,tp,LOCATION_DECK,0,3,3,nil)
        Duel.ConfirmCards(1-tp,sg)
        Duel.ShuffleDeck(tp)  -- 展示后洗切卡组
    end
    return true
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- ②目标：检索雷霆永续魔法
function s.thfilter1(c)
	return c:IsSetCard(0xeae9) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.thfilter2(c)
	return c:IsAbleToHand()
end
function s.reg_ret(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(s.returnop)
	c:RegisterEffect(e1)
end
function s.returnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(s.thfilter2,tp,LOCATION_MZONE,0,nil)
			local tg=g:Filter(Card.IsControler,nil,tp)
			if #tg>0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
			end
		end
	end
end
