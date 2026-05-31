--混沌超量 阴影骑士·梦魇
function c71280011.initial_effect(c)
	aux.AddCodeList(c,2061963)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3,c71280011.ovfilter,aux.Stringid(71280011,0),3,c71280011.xyzop)
	c:EnableReviveLimit()
	--x
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11280011)
	e1:SetTarget(c71280011.xtg)
	e1:SetOperation(c71280011.xop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21280011)
	e2:SetCost(c71280011.tgcost)
	e2:SetTarget(c71280011.tgtg)
	e2:SetOperation(c71280011.tgop)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,71280011)
	e3:SetCondition(c71280011.spcon)
	e3:SetTarget(c71280011.sptg)
	e3:SetOperation(c71280011.spop)
	c:RegisterEffect(e3)
	if not c71280011.global_check then
		c71280011.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c71280011.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c71280011.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		Duel.RegisterFlagEffect(ep,71280011,RESET_PHASE+PHASE_END,0,1)
	end
end
function c71280011.ovfilter(c)
	return c:IsFaceup() and c:IsCode(71280010)
end
function c71280011.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,71280010)==0 end
	Duel.RegisterFlagEffect(tp,71280010,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c71280011.ofilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e)) and (aux.IsCodeListed(c,2061963) or c:IsSetCard(0x87))
end
function c71280011.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c71280011.ofilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c71280011.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280011.ofilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e)
		local tc=g:GetFirst()
		if tc then
			Duel.Overlay(c,tc)
		end
	end
end
function c71280011.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71280011.tgfilter(c)
	return (c:IsCode(1127737) or c:IsCode(37511832) or aux.IsCodeListed(c,1127737)) and c:IsAbleToHand()
end
function c71280011.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71280011.tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c71280011.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280011.tgfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71280011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,71280011)~=0
end
function c71280011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71280011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end