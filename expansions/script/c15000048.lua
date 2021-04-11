local m=15000048
local cm=_G["c"..m]
cm.name="色带栖魔·格拉基"
function cm.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--SendtoGrave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0)) 
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,15000048) 
	e1:SetCondition(cm.tgcon)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,15010048) 
	e2:SetHintTiming(0,TIMING_MAIN_END)
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
function cm.cfilter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function cm.c2filter(c)  
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.IsExistingMatchingCard(cm.c2filter,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.c2filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()~=0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():IsLocation(LOCATION_ONFIELD) end  
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.tgfilter(c,e,tp,ft)
	return c:IsFaceup() and (ft>0 or c:GetSequence()<5) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode(),c:GetLeftScale(),c:GetRightScale(),c:GetRace())
end  
function cm.spfilter(c,e,tp,code,lse,rse,rac)  
	return c:IsRace(rac) and c:GetLeftScale()==lse and c:GetRightScale()==rse and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and not c:IsCode(code)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	local tp=e:GetHandlerPlayer() 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and cm.tgfilter(chkc,e,tp,ft) end  
	if chk==0 then return ft>-1 and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_PZONE,0,1,e:GetHandler(),e,tp,ft) end  
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