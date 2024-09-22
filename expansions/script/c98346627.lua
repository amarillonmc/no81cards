--未来的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c98346627.xyzfilter,8,3,c98346627.ovfilter,aux.Stringid(98346627,0),4,c98346627.xyzop)
	c:EnableReviveLimit()
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98346627,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(c98346627.atttg)
	e1:SetOperation(c98346627.attop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98346627,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+o)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98346627.matcon)
	e2:SetTarget(c98346627.mattg)
	e2:SetOperation(c98346627.matop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98346627,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+o*2)
	e3:SetCondition(c98346627.spcon)
	e3:SetTarget(c98346627.sptg)
	e3:SetOperation(c98346627.spop)
	c:RegisterEffect(e3)
end
function c98346627.xyzfilter(c)
	return c:IsSetCard(0xaf7)
end
function c98346627.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf7) and c:GetBaseAttack()>=2500 and not c:IsCode(98346627)
end
function c98346627.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98346627)==0 end
	Duel.RegisterFlagEffect(tp,98346627,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	e:GetHandler():RegisterFlagEffect(98346628,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
end
function c98346627.attfilter(c)
	return c:IsCanOverlay()
end
function c98346627.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98346627.attfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingTarget(c98346627.attfilter,tp,LOCATION_REMOVED,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g1=Duel.SelectTarget(tp,c98346627.attfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=Duel.SelectTarget(tp,c98346627.attfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		g1:Merge(g2)
end
function c98346627.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect and c98346627.attfilter,nil,e)
	if tg:GetCount()>0 then
		Duel.Overlay(c,tg)
	end
end
function c98346627.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetOverlayCount()>0
end
function c98346627.matfilter(c)
	return c:IsCanOverlay()
end
function c98346627.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98346627.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98346627.matfilter,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():GetFlagEffect(98346628)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c98346627.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c98346627.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsCanOverlay() then
		local og=c:GetOverlayGroup()
		if og:GetCount()==0 then return end
		Duel.SendtoGrave(og,REASON_EFFECT)
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c98346627.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousOverlayCountOnField()>0
end
function c98346627.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98346627.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
 		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end