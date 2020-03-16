--星宫六喰 降世
local m=33400657
local cm=_G["c"..m]
function cm.initial_effect(c)
		 --
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9342)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,m+80000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)  
	end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0 and Duel.GetFlagEffect(tp,m+80000)==0
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0 and Duel.GetFlagEffect(tp,m+80000)==0
end
function cm.refilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x340,0x341)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  if chkc then return chkc:IsLocation(LOCATION_REMOVED)  and cm.refilter(chkc) end 
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_REMOVED,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_REMOVED)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp) 
if not Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_REMOVED,0,1,nil)  then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)   
end