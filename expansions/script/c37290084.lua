--奇美拉结晶像
local cm,m=GetID()
function c37290084.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,286393)
	e2:SetCost(c286392.spcost2)
	e2:SetTarget(c286392.sptg2)
	e2:SetOperation(c286392.spop2)
	c:RegisterEffect(e2)
end
function cm.costfilter(c)
	return c:IsLevel(5) and c:IsType(TYPE_MONSTER)  and c:IsAbleToGraveAsCost()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,37290070,0x370,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,37290070,0x370,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP,1-tp) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,37290070)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
function c286392.cfilter(c,ft,tp)
	return c:IsCode(37290070)
end
function c286392.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_ONFIELD)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c286392.cfilter,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c286392.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.fit(c,e,tp)
	return  c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(5)
end
function c286392.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.fit,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c286392.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
			local g=Duel.SelectMatchingCard(tp,cm.fit,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end