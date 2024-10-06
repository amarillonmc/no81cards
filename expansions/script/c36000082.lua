--渊猎的圣铠

local cid=36000070
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,cid)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.eqlimit)
	c:RegisterEffect(e2)
		--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	
    --ToHandDeckGraveAndDiscardHand
    local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES+CATEGORY_GRAVE_ACTION+CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(s.tohcon)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.tohtg)
	e5:SetOperation(s.tohop)
	c:RegisterEffect(e5)
	
	--SpSumGraveAndToGraveFiledCard
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e6:SetCountLimit(1,id+1)
	e6:SetCondition(s.spcon)
	e6:SetTarget(s.sptg)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
	
end

function s.eqlimit(e,c)
	return aux.IsCodeListed(c,cid) 
end
function s.eqfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,cid) 
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end


--e5
--ToHandDeckGraveAndDiscardHand

function s.tohfilter(c,e,tp)
    return aux.IsCodeListed(c,cid) 
    and c:IsAbleToHand()
end

function s.disfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsDiscardable(REASON_EFFECT)
end

function s.tohtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.tohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_HAND,0,1,nil) end
    
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,0,LOCATION_HAND)
end

function s.tohop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    
    if not Duel.IsExistingMatchingCard(s.tohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	
	if not Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_HAND,0,1,g) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_HAND,0,1,1,g)
	Duel.SendtoGrave(dg,REASON_DISCARD+REASON_EFFECT)
end

function s.tohconfilter(c,tp)
    return aux.IsCodeListed(c,cid) and c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
end

function s.tohcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(s.tohconfilter,nil,tp)
end

--e6
--SpSumGraveAndToGraveFiledHandCard

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end

function s.spfilter(c,e,tp)
    return aux.IsCodeListed(c,cid) 
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

function s.togfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsAbleToGrave()
    and (not c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup())
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(s.togfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	    
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	    local tg=Duel.SelectMatchingCard(tp,s.togfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,g)
	    if tg:GetCount()>0 then
	        Duel.SendtoGrave(tg,REASON_EFFECT)    
	    end
	end
	
end
