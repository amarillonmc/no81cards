--支援龙

-- 支援龙 (卡号：40020187) 效果脚本
function c40020187.initial_effect(c)
	-- ①效果：每回合1次，从手卡或场上表侧送1只战士族/龙族怪兽，或10星怪兽，以及自身送墓为代价，特殊召唤1只「元素英雄」、「究极宝玉神」或「武装龙」怪兽，并从卡组检索「融合」或「超融合」
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,40020187)
	e1:SetCost(c40020187.spcost)
	e1:SetTarget(c40020187.sptg)
	e1:SetOperation(c40020187.spop)
	c:RegisterEffect(e1)
end

-- 费用过滤：战士族 or 龙族 or 等级10
function c40020187.cfilter(c)
	return (c:IsRace(RACE_WARRIOR) or (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND)) or c:IsLevel(10))
		and c:IsAbleToGraveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end

-- 支付费用：选择1只符合条件的怪兽（手卡或场上表侧），与自身一起送去墓地
function c40020187.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return c:IsAbleToGraveAsCost()
			and Duel.IsExistingMatchingCard(c40020187.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
	end
	-- 选择代价怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40020187.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	-- 将该卡加入费用组并一并送去墓地
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end

-- 特殊召唤过滤：元素英雄/究极宝玉神/武装龙 系列
function c40020187.spfilter(c,e,tp)
	return (c:IsSetCard(0x3008) or c:IsSetCard(0x2034) or c:IsSetCard(0x111))
		 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

-- 目标选择：确认是否存在可特殊召唤目标和「融合/超融合」可检索
function c40020187.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c40020187.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		   and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,24094653,48130397)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- 效果执行：特殊召唤并检索「融合/超融合」
function c40020187.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	-- 特殊召唤：从卡组或墓地选择1只符合条件的怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40020187.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 then
			-- 忽略召唤条件后完成程序
			-- 检索1张「融合」或「超融合」加入手卡
			if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,24094653,48130397) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,24094653,48130397)
				if tg:GetCount()>0 then
					Duel.SendtoHand(tg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tg)
				end
			end
		end
	end
end
