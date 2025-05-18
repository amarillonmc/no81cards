-- 幻殇龙裔（最终版）
local s, id = GetID()

function s.initial_effect(c)
	-- 规则上当作「龙裔」卡使用
	
	-- ①效果：从卡组除外「龙裔」魔陷或加入「幻殇」怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- ②效果：被「龙裔/幻殇」卡送墓时回收墓地1张「龙裔」卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon1)
	e2:SetTarget(s.thtg1)
	e2:SetOperation(s.thop1)
	c:RegisterEffect(e2)
	
	-- ③效果：被「龙裔/幻殇」卡除外时从卡组特召「幻殇」怪兽
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
end

-- ①效果处理
function s.thfilter1(c)
	return c:IsSetCard(0x6450) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function s.thfilter2(c)
	return c:IsSetCard(0x3450) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() -- 假设0x6451是「幻殇」的SETCODE
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

-- ②效果处理
function s.cfilter(c,tp)
	return (c:IsSetCard(0x6450) or c:IsSetCard(0x3450)) and c:IsControler(tp)
end
function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return re and (re:GetHandler():IsSetCard(0x3450) or re:GetHandler():IsSetCard(0x6450)) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_DECK)
end
function s.thfilter3(c)
	return c:IsSetCard(0x6450) and c:IsAbleToHand()
end
function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- ③效果处理
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and (re:GetHandler():IsSetCard(0x3450) or re:GetHandler():IsSetCard(0x6450)) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3450) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
