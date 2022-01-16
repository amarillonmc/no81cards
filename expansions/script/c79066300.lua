--伪骸屑机
function c79066300.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79066300,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,79066300)
	e1:SetCondition(c79066300.spcon)
	e1:SetTarget(c79066300.sptg)
	e1:SetOperation(c79066300.spop)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79066300,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,19066300)
	e3:SetCost(c79066300.thcost)
	e3:SetTarget(c79066300.thtg)
	e3:SetOperation(c79066300.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--get effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79066300,1))
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1,29066300)
	e5:SetCondition(c79066300.discon)
	e5:SetCost(c79066300.discost)
	e5:SetTarget(c79066300.distg)
	e5:SetOperation(c79066300.disop)
	c:RegisterEffect(e5)
end
function c79066300.ckfil(c)
	return c:IsLevel(5) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c79066300.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:IsExists(c79066300.ckfil,1,nil)
end
function c79066300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79066300.pbfil(c)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return no and no==53 and c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)
end
function c79066300.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	if Duel.GetFlagEffect(tp,79066300)==0 and Duel.IsExistingMatchingCard(c79066300.pbfil,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79066300,0)) then
	local g=Duel.SelectMatchingCard(tp,c79066300.pbfil,tp,LOCATION_EXTRA,0,1,1,nil) 
	Duel.ConfirmCards(1-tp,g)
	local token=Duel.CreateToken(tp,97403510) 
	Duel.SendtoDeck(token,nil,2,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
	Duel.RegisterFlagEffect(tp,79066300,0,0,0)
	end
end
function c79066300.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c79066300.thfilter(c)
	return c:IsCode(44682448) and c:IsAbleToHand()
end
function c79066300.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79066300.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79066300.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79066300.thfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79066300.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return no and no==53 and c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp
		and Duel.IsChainNegatable(ev)
end
function c79066300.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,x,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,x,x,REASON_COST)
end
function c79066300.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c79066300.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.SelectYesNo(tp,aux.Stringid(79066300,1)) then 
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.Destroy(g,REASON_EFFECT)
	end
end

