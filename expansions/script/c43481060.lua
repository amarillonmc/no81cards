--世界樹の輪転
-- 效果：
-- ①：1回合1次可以发动。从自己卡组·墓地把1只有「圣域 世界树-维里斯佩克斯」（43481000）卡名记述的怪兽加入手卡。
-- ②：1回合1次，10星或10阶的光属性·水族怪兽因对方从自己场上离开的场合才能发动。选自己手卡·墓地·除外的1只有「圣域 世界树-维里斯佩克斯」卡名记述的怪兽特殊召唤。
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,43481000)
	-- 永续魔法的“允许发动”空效果
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- ①：1回合1次可以发动。从自己卡组·墓地把1只有「圣域 世界树-维里斯佩克斯」卡名记述的怪兽加入手卡。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	-- ②：1回合1次，10星或10阶的光属性·水族怪兽因对方从自己场上离开的场合才能发动。选自己手卡·墓地·除外的1只有「圣域 世界树-维里斯佩克斯」卡名记述的怪兽特殊召唤。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
-- 效果①的检索过滤器：有「圣域 世界树-维里斯佩克斯」卡名记述的怪兽，且能加入手卡
function s.thfilter(c)
	return aux.IsCodeListed(c,43481000) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
-- 效果①的发动准备与合法性检查
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
-- 效果①的效果处理
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- 效果②的离场过滤器：10星或10阶的光属性·水族怪兽，因对方从自己场上离开
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
		and (c:IsLevel(10) or c:IsRank(10))
		and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_AQUA)
		and c:GetReasonPlayer()==1-tp
end
-- 效果②的发动条件
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
-- 效果②的特殊召唤过滤器：有「圣域 世界树-维里斯佩克斯」卡名记述的怪兽，且能特殊召唤
function s.spfilter(c,e,tp)
	return aux.IsCodeListed(c,43481000) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
-- 效果②的发动准备与合法性检查
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
-- 效果②的效果处理
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end