--Invictus Gaming
function c9981569.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_XYZ))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Rank Up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981569,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9981569)
	e3:SetTarget(c9981569.target)
	e3:SetOperation(c9981569.operation)
	c:RegisterEffect(e3)
	 --spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9981569,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c9981569.spcon)
	e5:SetTarget(c9981569.sptg)
	e5:SetOperation(c9981569.spop)
	c:RegisterEffect(e5)
end
function c9981569.immtg(e,c)
	return c:IsSetCard(0x9bce) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c9981569.tgfilter(c,e,tp)
	if not (c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x9bce)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)) then return false end
	return Duel.IsExistingMatchingCard(c9981569.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank()+1,c)
end
function c9981569.spfilter(c,e,tp,rank,mc)
	return c:IsType(TYPE_XYZ) and c:IsRank(rank) and mc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c9981569.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9981569.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9981569.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9981569.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9981569.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup()
		and Duel.GetLocationCountFromEx(tp,tp,tc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9981569.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank()+1,tc)
		local sc=g:GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9981569.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9981569.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_XYZ)
end
function c9981569.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=1000
end
function c9981569.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsPlayerCanSpecialSummon(tp)
		and Duel.GetLocationCountFromEx(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9981569.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummon(tp)
		or Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 then return end
	Duel.ShuffleExtra(tp)
	Duel.ConfirmExtratop(tp,1)
	local tc=Duel.GetExtraTopGroup(tp,1):GetFirst()
	if tc:IsType(TYPE_XYZ) and tc:IsSetCard(0x9bce) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end