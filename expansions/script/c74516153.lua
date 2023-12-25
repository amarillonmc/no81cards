--人偶·伊汐尔
function c74516153.initial_effect(c)
	--to grave/special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,74516153)
	e1:SetTarget(c74516153.tgtg)
	e1:SetOperation(c74516153.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--ritual level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(c74516153.rlevel)
	c:RegisterEffect(e3)
end
function c74516153.filter(c,ct,e,tp)
	return c:IsSetCard(0x745) and c:IsType(TYPE_MONSTER) and ((c:IsAbleToGrave() and ct==1) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ct==2))
end
function c74516153.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	if e:GetHandler():IsAttackPos() then
		ct=1
	elseif e:GetHandler():IsDefensePos() then
		ct=2
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c74516153.filter,tp,LOCATION_DECK,0,1,nil,ct,e,tp) end
	if ct==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif ct==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)	
	end
end
function c74516153.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=0
	if c:IsAttackPos() then
		ct=1
	elseif c:IsDefensePos() then
		ct=2
	end
	if ct==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c74516153.filter,tp,LOCATION_DECK,0,1,1,nil,ct,e,tp)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif ct==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c74516153.filter,tp,LOCATION_DECK,0,1,1,nil,ct,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c74516153.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsLevel(8) and c:IsSetCard(0x745) then
		local clv=c:GetLevel()
		return (lv<<16)+clv
	else return lv end
end
