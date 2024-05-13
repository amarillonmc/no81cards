--掩映紫炎蔷薇的音色
function c9911567.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911567,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9911567)
	e1:SetCondition(c9911567.spcon)
	e1:SetTarget(c9911567.sptg)
	e1:SetOperation(c9911567.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911567,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9911568)
	e2:SetCondition(c9911567.thcon)
	e2:SetCost(c9911567.thcost)
	e2:SetTarget(c9911567.thtg)
	e2:SetOperation(c9911567.thop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,9911569)
	e3:SetCondition(c9911567.drcon)
	e3:SetTarget(c9911567.drtg)
	e3:SetOperation(c9911567.drop)
	c:RegisterEffect(e3)
end
function c9911567.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c9911567.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911567.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9911567.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9911567.posfilter(c)
	return c:IsLocation(LOCATION_MZONE) and (c:IsCanTurnSet() or not c:IsPosition(POS_FACEUP_ATTACK))
end
function c9911567.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1
		or Duel.IsPlayerAffectedByEffect(tp,59822133) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911567.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g1>0 then
		g1:AddCard(c)
		if Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)>0 then
			local g2=Duel.GetMatchingGroup(c9911567.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			if #g2==0 then return end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sc=g2:Select(tp,1,1,nil):GetFirst()
			if sc:IsPosition(POS_FACEUP_ATTACK) then
				Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE)
			elseif sc:IsPosition(POS_FACEDOWN_DEFENSE) then
				Duel.ChangePosition(sc,POS_FACEUP_ATTACK)
			elseif sc:IsCanTurnSet() then
				local pos=Duel.SelectPosition(tp,sc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
				Duel.ChangePosition(sc,pos)
			else
				Duel.ChangePosition(sc,POS_FACEUP_ATTACK)
			end
		end
	end
end
function c9911567.thcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6952)
end
function c9911567.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9911567.thcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9911567.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9911567.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9911567.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
function c9911567.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()>1 and eg:IsContains(e:GetHandler())
end
function c9911567.cfilter(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsCanBeEffectTarget(e)
end
function c9911567.fselect(g,tp)
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	local num=math.floor(math.abs(lv1-lv2)/2)
	return num>0 and Duel.IsPlayerCanDraw(tp,num)
end
function c9911567.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Filter(c9911567.cfilter,nil,e)
	if chk==0 then return #g>1 and g:CheckSubGroup(c9911567.fselect,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=g:SelectSubGroup(tp,c9911567.fselect,false,2,2,tp)
	Duel.SetTargetCard(g1)
	local lv1=g1:GetFirst():GetLevel()
	local lv2=g1:GetNext():GetLevel()
	local num=math.floor(math.abs(lv1-lv2)/2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,num)
end
function c9911567.cfilter2(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c9911567.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9911567.cfilter2,nil,e)
	if #g~=2 then return end
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	local num=math.floor(math.abs(lv1-lv2)/2)
	if num<1 then return end
	Duel.Draw(tp,num,REASON_EFFECT)
end
