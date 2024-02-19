local m=15000048
local cm=_G["c"..m]
cm.name="色带栖魔·格拉基"
function cm.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,15010048) 
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)
end
function cm.matfilter(c)  
	return c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(cm.mat2filter,c:GetOwner(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c:GetLeftScale(),c:GetRightScale())
end 
function cm.mat2filter(c,lse,rse)  
	return c:GetLeftScale()==lse and c:GetRightScale()==rse
end 
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():IsLocation(LOCATION_ONFIELD) end  
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.tgfilter(c,e,tp,ft)
	return c:IsFaceup() and (ft>0 or e:GetHandler():GetSequence()<5) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode(),c:GetLeftScale(),c:GetRightScale(),c:GetRace())
end  
function cm.spfilter(c,e,tp,code,lse,rse,rac)  
	return c:IsType(TYPE_PENDULUM) and c:IsRace(rac) and c:GetLeftScale()==lse and c:GetRightScale()==rse and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and not c:IsCode(code)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	local tp=e:GetHandlerPlayer() 
	local ft=Duel.GetMZoneCount(tp,e:GetHandler(),tp) 
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and cm.tgfilter(chkc,e,tp,ft) end  
	if chk==0 then return ft>0 and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_PZONE,0,1,e:GetHandler(),e,tp,ft) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tp=e:GetHandlerPlayer() 
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode(),tc:GetLeftScale(),tc:GetRightScale(),tc:GetRace())
	if sg:GetCount()>0 then  
		Duel.BreakEffect()  
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end