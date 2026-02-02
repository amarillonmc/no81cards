--岩嗣引路者 凯西
local s,id=GetID()

function s.initial_effect(c)
	-- 连接召唤设置
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.mfilter,1,1)
	
	-- 效果①：连接召唤成功时发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.sumlimit)
	c:RegisterEffect(e2)
end

-- 连接素材过滤器：攻击力1000以上的恶魔族·地属性怪兽
function s.mfilter(c)
	return c:IsAttackAbove(1000) and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.sumlimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
-- 效果①：发动条件（连接召唤成功）
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
-- 效果①：目标设定
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查卡组是否有岩嗣怪兽可以送墓
		return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

-- 送墓过滤器（岩嗣怪兽）
function s.tgfilter(c)
	return c:IsSetCard(0x396d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

-- 效果①：操作处理
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	-- 检查卡组是否有岩嗣怪兽
	if not Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) then return end
	
	-- 从卡组选择1只岩嗣怪兽送去墓地
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		
		-- 记录这个效果在决斗中已使用
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end