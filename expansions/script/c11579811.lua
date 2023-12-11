--装弹枪管爆裂龙
function c11579811.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(function(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) end)
	c:RegisterEffect(e1) 
	--des 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) 
	e2:SetTarget(c11579811.destg) 
	e2:SetOperation(c11579811.desop) 
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_DESTROYED) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,11579811) 
	e3:SetCondition(function(e) 
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE) end)
	e3:SetTarget(c11579811.sptg)
	e3:SetOperation(c11579811.spop)
	c:RegisterEffect(e3)
end
function c11579811.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsRace(RACE_DRAGON) end,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g1=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsRace(RACE_DRAGON) end,tp,LOCATION_MZONE,0,1,1,nil) 
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)  
	g1:Merge(g2) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0) 
	Duel.SetChainLimit(c11579811.chlimit)
end
function c11579811.chlimit(e,ep,tp)
	return tp==ep
end 
function c11579811.desop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then 
		Duel.Destroy(g,REASON_EFFECT)   
	end 
end 
function c11579811.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11579811.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11579811.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11579811.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c11579811.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end 
end






