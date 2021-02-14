local m=15000320
local cm=_G["c"..m]
cm.name="内核实体 荧廖月"
function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_TO_GRAVE)  
	e1:SetCountLimit(1,15000320)  
	e1:SetCondition(cm.spcon)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetCondition(cm.spcon2)  
	c:RegisterEffect(e2)
	--remove overlay replace  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,15010320)  
	e3:SetCondition(cm.rcon)  
	e3:SetOperation(cm.rop)  
	c:RegisterEffect(e3)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:GetHandler():IsSetCard(0xf39) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end  
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()  
	return (e:GetHandler():IsReason(REASON_BATTLE) or e:GetHandler():IsReason(REASON_EFFECT)) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsPlayerAffectedByEffect(tp,15000330)  
end
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0xf39) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandler():GetControler()  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandler():GetControler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end 
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and tc:IsLocation(LOCATION_GRAVE) then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
	end  
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToGraveAsCost() and ep==e:GetOwnerPlayer() and re:GetHandler():IsSetCard(0xf39)
end  
function cm.rop(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end