-- 九龙之子（场地魔法）
-- 卡号：60000207（假设）
local s, id = GetID()

local CARD_PULAO = 60000196	  -- 蒲牢·华钟的卡号
local WANSHI_COUNTER = 0x62b	 -- 万世铭指示物类型

function s.initial_effect(c)
	aux.AddCodeList(c,CARD_PULAO)
	
	-- ①：发动时可选攻击力翻倍（修正后）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.doubleop)
	c:RegisterEffect(e1)
	
	-- ②：检索+指示物
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 效果①：攻击力翻倍（修正后）
function s.doubleop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetAttack()*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

-- 效果②：检索处理（保持不变）
function s.thfilter(c)
	return c:IsAbleToHand() and aux.IsCodeListed(c,CARD_PULAO) and not c:IsCode(id)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,tp,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,g)
	local pl=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,CARD_PULAO)
	if #pl==0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=pl:Select(tp,1,1,nil):GetFirst()
		if tc and tc:IsCanAddCounter(WANSHI_COUNTER,1) and tc:GetCounter(WANSHI_COUNTER)<4 then
			tc:AddCounter(WANSHI_COUNTER,1)
		end
	end
end