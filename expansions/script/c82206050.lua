local m=82206050
local cm=_G["c"..m]
cm.name="植占师30-弹射"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)  
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e2) 
	--destroy 
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,82216050)  
	e3:SetTarget(cm.sptg2)  
	e3:SetOperation(cm.spop2)  
	c:RegisterEffect(e3)  
end
function cm.filter(c,e,tp)  
	return c:IsSetCard(0x129d) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  
function cm.tgfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x29d)  
end  
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()  
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and cm.tgfilter(chkc) and chkc~=c end  
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_ONFIELD,0,1,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_ONFIELD,0,1,1,c)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then  
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end  
end  