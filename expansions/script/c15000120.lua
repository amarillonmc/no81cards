local m=15000120
local cm=_G["c"..m]
cm.name="银河眼轻雷时空龙"
function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(15000120,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e1:SetCountLimit(1,15000120)  
	e1:SetCondition(c15000120.spcon)  
	e1:SetTarget(c15000120.sptg)  
	e1:SetOperation(c15000120.spop)  
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(15000120,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e2:SetCountLimit(1,15000120)  
	e2:SetCondition(c15000120.matcon) 
	e2:SetTarget(c15000120.mattg)
	e2:SetOperation(c15000120.matop)  
	c:RegisterEffect(e2)
	--get effect  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(15000120,2))  
	e3:SetCategory(CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetCountLimit(1)
	e3:SetCondition(c15000120.shcon)  
	e3:SetCost(c15000120.shcost)
	e3:SetOperation(c15000120.shop)  
	c:RegisterEffect(e3)
end
function c15000120.cfilter(c)  
	return c:IsType(TYPE_XYZ) or c:IsSetCard(0x107b)
end
function c15000120.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c15000120.cfilter,1,nil)  
end  
function c15000120.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function c15000120.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end  
end
function c15000120.wfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x107b)
end  
function c15000120.matcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c15000120.cfilter,1,nil) and Duel.IsExistingMatchingCard(c15000120.wfilter,tp,LOCATION_MZONE,0,1,nil)
end  
function c15000120.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c15000120.tgfilter(chkc,tp,eg) end  
	if chk==0 then return Duel.IsExistingTarget(c15000120.wfilter,tp,LOCATION_MZONE,0,1,nil,tp,eg) and e:GetHandler():IsCanOverlay() end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	Duel.SelectTarget(tp,c15000120.wfilter,tp,LOCATION_MZONE,0,1,1,nil)  
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function c15000120.matop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,e:GetHandler())  
	end
end
function c15000120.shfilter(c)  
	return (c:IsCode(89789152) or c:IsCode(59650656) or c:IsCode(8038143) or (c:IsSetCard(0x95) and c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL))) and c:IsAbleToHand()
end
function c15000120.shcon(e,tp,eg,ep,ev,re,r,rp)  
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and e:GetHandler():IsSetCard(0x307b) and Duel.IsExistingMatchingCard(c15000120.shfilter,tp,LOCATION_DECK,0,1,nil)
end
function c15000120.shcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end
function c15000120.shop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c15000120.shfilter,tp,LOCATION_DECK,0,1,1,nil) 
	if g:GetCount()~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end