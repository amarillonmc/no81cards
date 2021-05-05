--银河眼次时空龙
function c40009221.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009221)
	e1:SetCondition(c40009221.spcon)
	e1:SetOperation(c40009221.spop)
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009221,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c40009221.target)
	e2:SetOperation(c40009221.operation)
	c:RegisterEffect(e2)  
	--disable attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009221,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40009222)
	e3:SetTarget(c40009221.spxtg)
	e3:SetOperation(c40009221.spxop)
	c:RegisterEffect(e3) 
end
function c40009221.spcfilter(c)
	return c:IsSetCard(0x107b) and not c:IsPublic()
end
function c40009221.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009221.spcfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function c40009221.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c40009221.spcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
end
function c40009221.filter(c)
	return ((c:IsSetCard(0x95) and c:IsType(TYPE_SPELL)) or c:IsCode(8038143) or c:IsCode(59650656) or c:IsCode(89789152)) and c:IsAbleToHand()
end
function c40009221.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009221.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40009221.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40009221.spfilter(c,e,tp)
	return c:IsCode(88177324) and c:IsType(TYPE_XYZ)
		and e:GetHandler():IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c40009221.spxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c40009221.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetRank()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009221.spxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsFaceup()
		and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c40009221.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler():GetRank())
		local tc=g:GetFirst()
		if tc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(tc,mg)
			end
			tc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(tc,Group.FromCards(c))
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
