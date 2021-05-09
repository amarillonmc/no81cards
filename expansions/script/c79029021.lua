--乌萨斯·先锋干员-凛冬
function c79029021.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--th
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029021)
	e1:SetCost(c79029021.thcost)
	e1:SetTarget(c79029021.thtg)
	e1:SetOperation(c79029021.thop)
	c:RegisterEffect(e1)   
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,09029021)
	e2:SetTarget(c79029021.sptg)
	e2:SetOperation(c79029021.spop)
	c:RegisterEffect(e2)
end
function c79029021.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029021.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0xa900)
end
function c79029021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029021.thfil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end
	Debug.Message("走了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029021,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029021.thfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function c79029021.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsSetCard(0xa903) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(79029021,0)) then 
	Debug.Message("怕什么！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029021,2))
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79029021.ckfil(c)
	return c:IsSetCard(0xa900) and c:IsCanOverlay() 
end
function c79029021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c79029021.ckfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c79029021.ckfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029021.spop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我要去战斗。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029021,3))
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(c,mg)
		end
		c:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(c,Group.FromCards(tc))
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end 
end








