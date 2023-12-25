--人偶宣召·月女神雪拉
function c74539103.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c74539103.splimit)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74539103,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,74539103)
	e2:SetTarget(c74539103.thtg)
	e2:SetOperation(c74539103.thop)
	c:RegisterEffect(e2)
	--ritual summon
	local e3=aux.AddRitualProcEqual2(c,c74539103.rsfilter,LOCATION_HAND+LOCATION_GRAVE,nil,c74539103.matfilter,true,c74539103.extraop)
	e3:SetDescription(aux.Stringid(74539103,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,84539103)
	e3:SetCost(c74539103.rscost)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c74539103.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e5)
end
function c74539103.splimit(e,se,sp,st)
	return st&SUMMON_TYPE_RITUAL~=SUMMON_TYPE_RITUAL or (se and se:GetHandler():IsSetCard(0x745))
end
function c74539103.thfilter(c)
	return c:IsAbleToHand()
end
function c74539103.spfilter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x745) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74539103.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return e:GetHandler():IsAbleToHand() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c74539103.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c74539103.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c74539103.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c74539103.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local rg=Group.FromCards(c,tc)
		if Duel.SendtoHand(rg,nil,REASON_EFFECT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.BreakEffect()
			local sg=Duel.SelectMatchingCard(tp,c74539103.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c74539103.rsfilter(c,e,tp,chk)
	return c:IsSetCard(0x745)
end
function c74539103.matfilter(c,e,tp,chk)
	return c~=e:GetHandler()
end
function c74539103.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
end
function c74539103.tdfilter(c,e,tp)
	return Card.IsAbleToDeck(c) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c74539103.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	if not tc then return end
	Duel.BreakEffect()
	local sg=Duel.SelectMatchingCard(tp,c74539103.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c74539103.atkfilter(c)
	return c:IsSetCard(0x745) and c:IsType(TYPE_MONSTER)
end
function c74539103.atkval(e,c)
	return Duel.GetMatchingGroupCount(c74539103.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end
