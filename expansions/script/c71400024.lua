--幽禁异梦的狐侍与魔女
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400024.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c71400024.lcheck(c))
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400024,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,71400024)
	e1:SetTarget(c71400024.tg1)
	e1:SetOperation(c71400024.op1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400024,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,71500024)
	e2:SetCondition(c71400024.con2)
	e2:SetTarget(c71400024.tg2)
	e2:SetOperation(c71400024.op2)
	c:RegisterEffect(e2)
end
function c71400024.lcheck(c)
	return function(g) return yume.IsYumeFieldOnField(c:GetControler()) and g:IsExists(c71400024.lcfilter,1,nil) end
end
function c71400024.lcfilter(c)
	return c:GetBaseAttack()>2500 and c:GetOriginalAttribute()==ATTRIBUTE_DARK and c:IsLinkSetCard(0x714)
end
function c71400024.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c71400024.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c71400024.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c71400024.filter2(c,e,tp)
	return c:GetBaseAttack()>2500 and c:GetOriginalAttribute()==ATTRIBUTE_DARK and c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(71400024)
end
function c71400024.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71400024.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c71400024.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ct=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ct>2 then ct=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71400024.filter2,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c71400024.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end