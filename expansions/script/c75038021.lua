--抒情歌鸲-合唱小琉璃·颂鸣赞礼
function c75038021.initial_effect(c)
	c:SetSPSummonOnce(75038021)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c75038021.mfilter,nil,2,2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75038021,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e1:SetTarget(c75038021.sptg)
	e1:SetOperation(c75038021.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function(e,c)
	return c:GetOverlayCount()*700 end)
	c:RegisterEffect(e2) 
	--xyz
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(75038021,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1) 
	e3:SetCondition(c75038021.xyzcon)
	e3:SetCost(c75038021.xyzcost)
	e3:SetTarget(c75038021.xyztg)
	e3:SetOperation(c75038021.xyzop)
	c:RegisterEffect(e3)
end 
function c75038021.mfilter(c)
	return c:IsSetCard(0xf7) and (c:IsRank(1) or c:IsLevel(1))
end 
function c75038021.spfilter(c,e,tp)
	return c:IsSetCard(0xf7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75038021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75038021.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c75038021.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75038021.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c75038021.xckfil(c,tp) 
	return c:IsControler(tp) and c:IsSetCard(0xf7) 
end 
function c75038021.xyzcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ) and eg:IsExists(c75038021.xckfil,1,nil,tp) 
end 
function c75038021.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end 
function c75038021.xyzfilter(c,e,tp)
	local mg=Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	return c:IsXyzSummonable(mg,1,99) and c:IsSetCard(0xf7) 
end
function c75038021.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c75038021.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c75038021.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75038021.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end 
end 



