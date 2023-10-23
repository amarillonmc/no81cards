--人理之基 梅露辛
function c22022850.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,22021730),1,1)
	c:EnableReviveLimit()
	--synchro effect
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(22022850,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCountLimit(1,22022850+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c22022850.sccon)
	e1:SetTarget(c22022850.sctarg)
	e1:SetOperation(c22022850.scop)
	c:RegisterEffect(e1) 
	--xyz  
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(22022850,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12022850) 
	e2:SetTarget(c22022850.xyztg)
	e2:SetOperation(c22022850.xyzop)
	c:RegisterEffect(e2)
end
function c22022850.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp==tp and re:GetHandler():IsCode(22021730)
end
function c22022850.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local mg=Duel.GetMatchingGroup(function(c) return c:IsCanBeSynchroMaterial() and c:IsSetCard(0x2ff1) end,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,mg,nil,1,99) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22022850.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(function(c) return c:IsCanBeSynchroMaterial() and c:IsSetCard(0x2ff1) end,tp,LOCATION_MZONE,0,nil) 
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,mg,nil,1,99)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,1,99)  
	end
end
function c22022850.xyzfil(c,e,tp,mc) 
	return c:IsCode(22022890) and c:IsType(TYPE_XYZ)
		and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c22022850.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(c22022850.xyzfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsCanOverlay,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22022850.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		Duel.SelectOption(tp,aux.Stringid(22022850,2))
		Duel.SelectOption(tp,aux.Stringid(22022850,3))
		local g=Duel.SelectMatchingCard(tp,c22022850.xyzfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local tc=g:GetFirst()
		if tc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.Overlay(tc,mg)
			end
			tc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(tc,Group.FromCards(c))
			if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then  
				tc:CompleteProcedure() 
				local oc=Duel.GetFirstTarget() 
				if oc:IsRelateToEffect(e) then 
					Duel.Overlay(tc,oc) 
				end  
			end 
		end
	end
end









