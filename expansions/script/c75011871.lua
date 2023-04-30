--升阶魔法-群集聚变
function c75011871.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,75011871) 
	e1:SetTarget(c75011871.actg) 
	e1:SetOperation(c75011871.acop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,15011871) 
	e2:SetCondition(c75011871.thcon)
	e2:SetTarget(c75011871.thtg) 
	e2:SetOperation(c75011871.thop) 
	c:RegisterEffect(e2) 
end 
c75011871.SetCard_TT_JGRD=true 
function c75011871.ovfil(c) 
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanOverlay() 
end 
function c75011871.xxfil(c,e,tp) 
	local g=Duel.GetMatchingGroup(c75011871.ovfil,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c)
	return c:IsFaceup() and c.SetCard_TT_JGRD and c:IsType(TYPE_XYZ) and g:GetCount()>0 
end 
function c75011871.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c75011871.xxfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c75011871.xxfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c75011871.espfil(c,e,tp,sc,x)  
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsType(TYPE_XYZ) and c.SetCard_TT_JGRD and c:IsRank(sc:GetRank()+x)  
end  
function c75011871.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		local g=Duel.GetMatchingGroup(c75011871.ovfil,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,tc) 
		if g:GetCount()>0 then 
			local og=g:Select(tp,1,99,nil) 
			Duel.Overlay(tc,og)  
			if Duel.IsExistingMatchingCard(c75011871.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc,og:GetCount()) and Duel.SelectYesNo(tp,aux.Stringid(75011871,0)) then 
				local sc=Duel.SelectMatchingCard(tp,c75011871.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,og:GetCount()):GetFirst()
				local mg=tc:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(tc))
				Duel.Overlay(sc,Group.FromCards(tc))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc:CompleteProcedure()
			end  
		end  
	end 
end 
function c75011871.ckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c.SetCard_TT_JGRD  
end 
function c75011871.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c75011871.ckfil,1,nil,tp)   
end 
function c75011871.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end 
function c75011871.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoHand(c,nil,2,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,c)   
	end 
end 






