--星海航线 汇集的未来
function c11560713.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,11560713+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c11560713.target)
	e1:SetOperation(c11560713.activate)
	c:RegisterEffect(e1)
end 
c11560713.SetCard_SR_Saier=true  
function c11560713.filter1(c,e,tp) 
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c.SetCard_SR_Saier 
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c11560713.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c11560713.filter2(c,e,tp,mc) 
	local att=mc:GetAttribute() 
	local rc=mc:GetRace() 
	local b1=c:IsRace(rc) and not c:IsAttribute(att) 
	local b2=c:IsAttribute(att) and not c:IsRace(rc)  
	return (b1 or b2) and mc:IsCanBeXyzMaterial(c) and c.SetCard_SR_Saier 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c11560713.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c11560713.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11560713.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11560713.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL)
		or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11560713.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc) 
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11560713.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_CANNOT_SUMMON) 
	Duel.RegisterEffect(e2,tp) 
	local e3=e1:Clone() 
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON) 
	Duel.RegisterEffect(e3,tp) 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e4:SetTargetRange(1,0) 
	e4:SetValue(function(e,re,tp)
	return not (c.SetCard_SR_Saier and c:IsType(TYPE_MONSTER)) end)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp) 
end
function c11560713.splimit(e,c)
	return not c.SetCard_SR_Saier 
end

