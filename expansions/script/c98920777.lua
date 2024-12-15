--清透骸骨
local s,id,o=GetID()
function c98920777.initial_effect(c)
	aux.AddCodeList(c,33900648)
	--cannot be material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(c98920777.fuslimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	--attribute
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_ADD_ATTRIBUTE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(ATTRIBUTE_WIND+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_LIGHT)
	c:RegisterEffect(e7)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,98920777)
	e5:SetCost(c98920777.spcost)
	e5:SetTarget(c98920777.sptg)
	e5:SetOperation(c98920777.spop)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,13533679)
	e6:SetTarget(c98920777.thtg)
	e6:SetOperation(c98920777.thop)
	c:RegisterEffect(e6)
	--release limit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UNRELEASABLE_SUM)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(c98920777.recon)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
end
function c98920777.fuslimit(e,c,sumtype)
	return sumtype&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function c98920777.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c98920777.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920777.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or (not c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local toplayer=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0),tp},
		{b2,aux.Stringid(id,1),1-tp})
	if toplayer~=nil then
		Duel.SpecialSummon(c,0,tp,toplayer,false,false,POS_FACEUP)
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then
			Duel.SendtoGrave(c,REASON_RULE)
		end
	end
end
function c98920777.thfilter1(c)
	return c:IsCode(6089145) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98920777.thfilter2(c)
	return (aux.IsCodeListed(c,33900648) or c:IsCode(33900648)) and c:IsAbleToHand()
end
function c98920777.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920777.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920777.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if Duel.SelectYesNo(hp,aux.Stringid(98920777,3)) then
		   local hp=1-tp
		   Duel.Hint(HINT_SELECTMSG,hp,HINTMSG_ATOHAND)
		   local sg=Duel.SelectMatchingCard(hp,c98920777.thfilter2,hp,LOCATION_DECK,0,1,1,nil)
		   if sg:GetCount()>0 then
			  Duel.SendtoHand(sg,nil,REASON_EFFECT)
			  Duel.ConfirmCards(1-hp,sg)
		   end
		end
	end
end
function c98920777.recon(e,c)
	return not aux.IsCodeListed(c,33900648)
end