--破碎世界的倒吊人-忘却
--Broken World - The Hanged Man Oblivion
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,s.matfilter1,s.matfilter2,true)
	
	--①：特召检索 + 排序卡组顶
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	--②：墓地效果无效并除外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end

-- === 融合素材 ===
function s.matfilter1(c)
	return c:IsSetCard(0x616) and c:IsSummonLocation(LOCATION_EXTRA) and c:IsLocation(LOCATION_MZONE)
end

function s.matfilter2(c)
	return c:IsSetCard(0x616) and c:IsLocation(LOCATION_GRAVE)
end

-- === 效果① ===
function s.thfilter(c)
	return (c:IsSetCard(0x616) and c:GetType()==TYPE_TRAP)
		or (c:IsCode(6100276)) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.checkfilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			if Duel.IsExistingMatchingCard(s.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) 
				and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 
				and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.DisableShuffleCheck()
				Duel.SortDecktop(tp,tp,3)
			end
		end
	end
end

-- === 效果② ===
-- 检查：场上·墓地有「破碎世界」永续陷阱卡
function s.confilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	-- 对方把卡的效果发动
	return rp==1-tp and ((re:GetActivateLocation()==LOCATION_GRAVE) or (re:GetActivateLocation()==LOCATION_HAND))
		and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end