local m=82224066
local cm=_G["c"..m]
cm.name="DDD 混浊王 桑贾尔"
function cm.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep(c,cm.matfilter,2,true)  
	--reflect damage  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_REFLECT_DAMAGE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetValue(cm.refcon)  
	c:RegisterEffect(e1)   
	--spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)   
	e2:SetTarget(cm.sptg2)  
	e2:SetOperation(cm.spop2)  
	c:RegisterEffect(e2)  
end
function cm.matfilter(c)  
	return c:IsFusionSetCard(0xaf) and c:IsFusionAttribute(ATTRIBUTE_DARK)  
end  
function cm.refcon(e,re,val,r,rp,rc)  
	return bit.band(r,REASON_EFFECT)~=0 and (re:GetHandler():IsSetCard(0xaf) or re:GetHandler():IsSetCard(0xae)) and rp==e:GetHandlerPlayer()
end  
function cm.spfilter2(c,e,tp)  
	return c:IsFaceup() and c:IsSetCard(0xaf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end  
function cm.tgfilter(c,code)  
	return c:IsSetCard(0xaf) and c:IsAbleToGrave() and c:GetOriginalCodeRule()~=code
end  
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.spfilter2(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(cm.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	local code=tc:GetOriginalCodeRule()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil,code) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local tc2=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,code)
		Duel.BreakEffect()
		Duel.SendtoGrave(tc2,REASON_EFFECT)
	end
end  