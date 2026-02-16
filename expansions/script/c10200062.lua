-- 午夜战栗·未尽的凝视
function c10200062.initial_effect(c)
	-- 效果1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200062,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,{10200062,1})
	e1:SetTarget(c10200062.tdtg)
	e1:SetOperation(c10200062.tdop)
	c:RegisterEffect(e1)
	-- 效果2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200062,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{10200062,2})
	e2:SetCondition(c10200062.damcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10200062.damtg)
	e2:SetOperation(c10200062.damop)
	c:RegisterEffect(e2)
end
-- 1
function c10200062.tdfilter(c)
	return c:IsSetCard(0xe25) and c:IsAbleToDeck()
end
function c10200062.spfilter(c,e,tp)
	return c:IsSetCard(0xe25) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200062.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c10200062.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10200062.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SelectTarget(tp,c10200062.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_REMOVED)
end
function c10200062.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g or #g<3 then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)<3 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(c10200062.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(10200062,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c10200062.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.BreakEffect()
		local tc=sg:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
		Duel.SpecialSummonComplete()
	end
end
-- 2
function c10200062.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc:IsControler(1-tp) and tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_BATTLE)
		and bc and bc:IsSetCard(0xe25) and bc:IsControler(tp)
end
function c10200062.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc and tc:GetBaseAttack()>0 end
	local dam=tc:GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c10200062.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsLocation(LOCATION_GRAVE) then
		local dam=tc:GetBaseAttack()
		if dam>0 then
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
