local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：转移攻击目标
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	
	-- 效果②：检索字段
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	
	-- 效果③：直接攻击
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
end

-- 效果①条件：成为攻击对象
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) > 1
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local a,d=Duel.GetBattleMonster(0)
	local ad=Group.FromCards(a,d)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,ad)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,c,1,0,0)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT)~=0 then
		local tc=Duel.GetFirstTarget()
		local ag=Duel.GetAttacker() 
		if tc and tc:IsRelateToEffect(e) and ag:IsAttackable() and not ag:IsImmuneToEffect(e) then
			Duel.CalculateDamage(ag,tc)
		end
	end
end

-- 效果②条件：送墓场合
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

-- 效果②目标：检索「嗡嗡军团」怪兽
function s.thfilter(c)
	return c:IsSetCard(0x3962)  and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end