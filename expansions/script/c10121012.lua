--天使长 希望之奥瑞尔
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
local m=10121012
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsdio.AngelHandXyzEffect(c,true)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0)) 
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2) 
end
function cm.thfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_OVERLAY) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and cm.thfilter(chkc,e,tp) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if not tc:IsRelateToEffect(e) then return end
	local a1=tc:IsAbleToHand()
	local a2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if not a1 and not a2 then return end
	local op=rsof.SelectOption(tp,a1,1190,a2,1152)
	if op==1 then
	   if Duel.SendtoHand(tc,nil,REASON_EFFECT)<=0 then return end
	else
	   if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	end
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
	   c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end

