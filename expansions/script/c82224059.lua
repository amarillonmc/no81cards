local m=82224059
local cm=_G["c"..m]
cm.name="邪灵召唤师 戴勒斯缇亚"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--xyz summon  
	aux.AddXyzProcedure(c,nil,5,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)  
	c:EnableReviveLimit() 
	--special summon
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)	 
	e1:SetCountLimit(1)  
	e1:SetCost(cm.spcost)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1) 
	--cannot be target  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTargetRange(0,LOCATION_MZONE)  
	e4:SetValue(cm.tglimit)  
	c:RegisterEffect(e4)  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetTargetRange(LOCATION_MZONE,0)  
	e5:SetTarget(cm.tglimit)  
	e5:SetValue(aux.tgoval)  
	c:RegisterEffect(e5)   
end
function cm.ovfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:GetOriginalLevel()>=5
end  
function cm.xyzop(e,tp,chk)  
	if chk==0 then return true end	
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)  
end 
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end
function cm.tglimit(e,c)  
	return c:IsFaceup() and c:IsType(TYPE_FUSION) 
end  