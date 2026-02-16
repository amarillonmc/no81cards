-- 半魔的管家
local s,id=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3f50),7,2,nil,nil,99)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.ovcon)
	e0:SetTarget(s.ovtg)
	e0:SetOperation(s.ovop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1,id,RESET_PHASE+PHASE_END,0,1)
end
function s.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x3f50) and c:IsCanBeXyzMaterial(xyzc)
		and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0
end
function s.ovcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,id)>0 
		and Duel.GetFlagEffect(tp,id+1)==0
		and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_MZONE,0,nil,tp,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg=g:Select(tp,1,1,nil)
		if #mg>0 then
			mg:KeepAlive()
			e:SetLabelObject(mg)
			return true
		end
	end
	return false
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local mg=e:GetLabelObject()
	if not mg then return end
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
end
function s.rmfilter(c)
	return c:IsSetCard(0x3f50) and c:IsAbleToHand()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rmfilter),tp,LOCATION_REMOVED,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.spfilter(c,e,tp,check_earl)
	if not (c:IsSetCard(0x3f50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_DECK) then return check_earl end
	return c:IsLocation(LOCATION_HAND+LOCATION_REMOVED)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check_earl=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,17337413)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp,check_earl)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)~=0 then
		local check_earl=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,17337413)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp,check_earl)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end