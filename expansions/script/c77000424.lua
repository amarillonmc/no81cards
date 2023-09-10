--邪心英雄 梦魇怪魔
function c77000424.initial_effect(c)
	aux.AddCodeList(c,94820406)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6008),aux.FilterBoolFunction(Card.IsType,TYPE_LINK),true) 
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(function(e,se,sp,st)
	return se:GetHandler():IsCode(94820406)
		or Duel.IsPlayerAffectedByEffect(sp,72043279) and st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION end) 
	c:RegisterEffect(e0) 
	--immuse 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end) 
	e1:SetOperation(c77000424.imop) 
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE)  
	e2:SetValue(function(e) 
	local mg=e:GetHandler():GetMaterial() 
	local lk=mg:Filter(Card.IsType,nil,TYPE_LINK):GetSum(Card.GetLink)  
	return lk*600 end)
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,77000424)
	e3:SetCost(c77000424.spcost)
	e3:SetTarget(c77000424.sptg)
	e3:SetOperation(c77000424.spop)
	c:RegisterEffect(e3)
end
c77000424.material_setcode=0x8
c77000424.dark_calling=true
function c77000424.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,77000424) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsSetCard(0x6008) end) 
	e1:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
end 
function c77000424.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c77000424.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77000424.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77000424.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c77000424.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77000424.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end







