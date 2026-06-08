--三千大天
local m=43410015
local cm=_G["c"..m]

function cm.initial_effect(c)

	--①：丢弃1张手卡才能发动。选自己卡组1只4星以下的「罗生之蝶」怪兽加入手卡或特殊召唤。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)

	--②：自己场上有「罗生之蝶」怪兽存在的场合，把墓地的这张卡除外才能发动。随机丢弃对方1张手卡。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(cm.con2)
	e2:SetCost(aux.bfgcost) -- 除外墓地的自身作为Cost
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
end

-- ==========================================
-- ①效果相关函数
-- ==========================================
-- 代价：丢弃1张手卡
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 当这张卡本身从手卡发动时，丢弃的手卡不能是这张卡自己，所以需要排除 e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

-- 过滤：4星以下的「罗生之蝶」怪兽，且能加入手卡或能特殊召唤
function cm.filter1(c,e,tp)
	if not (c:IsSetCard(0xfb0) and c:IsLevelBelow(4)) then return false end
	local b1=c:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	return b1 or b2
end

function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
end

function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		
		-- 如果既能加入手卡又能特召，让玩家选择（1190: 加入手卡，1152: 特殊召唤）
		if b1 and b2 then
			if Duel.SelectOption(tp,1190,1152)==0 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		elseif b1 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		elseif b2 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

-- ==========================================
-- ②效果相关函数
-- ==========================================
-- 过滤：场上表侧表示的「罗生之蝶」怪兽
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfb0) and c:IsType(TYPE_MONSTER)
end

function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end

function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		-- 随机选择1张并丢弃
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end