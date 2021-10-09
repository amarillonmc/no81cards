--室内派·千石抚子
function c9950307.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9950307.spcon)
	c:RegisterEffect(e1)
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950307,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9950307)
	e2:SetCondition(c9950307.spcon2)
	e2:SetCost(c9950307.spcost)
	e2:SetTarget(c9950307.sptg)
	e2:SetOperation(c9950307.spop)
	c:RegisterEffect(e2)
	--Rank Up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950307,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,99503070)
	e3:SetTarget(c9950307.target)
	e3:SetOperation(c9950307.operation)
	c:RegisterEffect(e3)
end
function c9950307.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)==1
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c9950307.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c9950307.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9950307.filter(c,e,tp)
	return c:IsSetCard(0x5ba2) and c:IsType(TYPE_MONSTER) and not c:IsCode(9950307) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950307.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9950307.filter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9950307.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9950307.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c9950307.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if ft<sg:GetCount() or (sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9950307.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x5ba2)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c9950307.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank()-1,c)
end
function c9950307.spfilter(c,e,tp,rank,mc)
	return (c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_REPTILE)) and c:IsType(TYPE_XYZ) and c:IsRank(rank) and mc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9950307.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9950307.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9950307.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9950307.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950307.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup()
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9950307.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank()-1,tc)
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
	e1:SetTarget(c9950307.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9950307.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
