--魔法的始源·马纳历亚
function c72413440.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c72413440.sprcon)
	e2:SetOperation(c72413440.sprop)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c72413440.sumsuc)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(72413441)
	e4:SetTarget(c72413440.sptg)
	e4:SetOperation(c72413440.spop)
	c:RegisterEffect(e4)
end
--
function c72413440.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c72413440.tgrfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x5729)
end
function c72413440.tgrfilter2(c)
	return not c:IsType(TYPE_TUNER)
end
function c72413440.mnfilter(c,g)
	return g:IsExists(c72413440.mnfilter2,1,c,c)
end
function c72413440.mnfilter2(c,mc)
	return ((c:GetLevel()-mc:GetLevel()==3) or (mc:GetLevel()-c:GetLevel()==3))
end
function c72413440.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(c72413440.tgrfilter1,1,nil) and g:IsExists(c72413440.tgrfilter2,1,nil)
		and g:IsExists(c72413440.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c72413440.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c72413440.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c72413440.fselect,2,2,tp,c)
end
function c72413440.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c72413440.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c72413440.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end
--
function c72413440.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(72413440)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,72413440,nil,0,1)
end
--
function c72413440.spfilter(c,e,tp)
	return c:IsSetCard(0x5729) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72413440.thfilter(c,code)
	return c:IsSetCard(0x5729) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(code)
end
function c72413440.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72413440.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c72413440.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72413440.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
		Duel.BreakEffect()
		local code=g:GetFirst():GetCode()
		if Duel.IsExistingMatchingCard(c72413440.thfilter,tp,LOCATION_DECK,0,1,nil,code) and Duel.SelectYesNo(tp,aux.Stringid(72413440,0)) then
			local g2=Duel.SelectMatchingCard(tp,c72413440.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)  
			if g2:GetCount()>0 then Duel.SendtoHand(g2,tp,REASON_EFFECT) end
		end
   end
end