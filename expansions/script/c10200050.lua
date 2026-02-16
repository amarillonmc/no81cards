-- 午夜战栗·墓语旁白
function c10200050.initial_effect(c)
	-- 效果1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200050,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10200050)
	e1:SetCost(c10200050.sumcost)
	e1:SetTarget(c10200050.sumtg)
	e1:SetOperation(c10200050.sumop)
	c:RegisterEffect(e1)
	-- 效果2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200050,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{10200050,1})
	e2:SetTarget(c10200050.tgtg)
	e2:SetOperation(c10200050.tgop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	-- 效果3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200050,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,{10200050,2})
	e3:SetCondition(c10200050.spcon)
	e3:SetTarget(c10200050.sptg)
	e3:SetOperation(c10200050.spop)
	c:RegisterEffect(e3)
end
-- 1
function c10200050.cfilter(c)
	return c:IsSetCard(0xe25) and not c:IsPublic()
end
function c10200050.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(1) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c10200050.sumfilter(c,tp)
	return c:IsSetCard(0xe25) and c:IsLevelAbove(1)
end
function c10200050.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic()
		and Duel.IsExistingMatchingCard(c10200050.cfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10200050.cfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10200050.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200050.sumfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10200050.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10200050.sumfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	if #g>0 then
		local tc=g:GetFirst()
		if tc:IsSummonableCard() and c10200050.ntcon(nil,tc,0) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(10200050,3))
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SUMMON_PROC)
			e1:SetCondition(c10200050.ntcon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
-- 2
function c10200050.tgfilter(c)
	return c:IsSetCard(0xe25) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10200050.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200050.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10200050.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10200050.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
-- 3
function c10200050.posfilter(c,tp)
	return c:IsFacedown() and c:IsControler(tp) and c:IsPreviousPosition(POS_FACEUP)
end
function c10200050.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200050.posfilter,1,nil,tp)
end
function c10200050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10200050.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
