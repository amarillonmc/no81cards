--乳贴魔术师
function c9950419.initial_effect(c)
	 --synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950419,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9950419)
	e1:SetCondition(c9950419.sccon)
	e1:SetTarget(c9950419.sctg)
	e1:SetOperation(c9950419.scop)
	c:RegisterEffect(e1)
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950419,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9950419.sccon)
	e1:SetCountLimit(1,9950419)
	e1:SetTarget(c9950419.target)
	e1:SetOperation(c9950419.operation)
	c:RegisterEffect(e1)
end
function c9950419.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_SPELLCASTER)
end
function c9950419.sccon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9950419.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9950419.filter(c,e,tp,lv,mc)
	return c:IsFaceup() and c:GetLevel()>0
		and Duel.IsExistingMatchingCard(c9950419.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+c:GetOriginalLevel(),Group.FromCards(c,mc))
end
function c9950419.scfilter(c,e,tp,lv,mg)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevel(lv) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c9950419.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local lv=c:GetOriginalLevel()
	if chk==0 then return Duel.IsExistingTarget(c9950419.filter,tp,0,LOCATION_MZONE,1,nil,e,tp,lv,c)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c9950419.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp,lv,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950419.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	if Duel.SendtoGrave(g,REASON_EFFECT)==2 and c:GetLevel()>0 and c:IsLocation(LOCATION_GRAVE)
		and tc:GetLevel()>0 and tc:IsLocation(LOCATION_GRAVE) then
		local lv=c:GetLevel()+tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9950419.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function c9950419.tgfilter(c,tp,ec)
	local mg=Group.FromCards(ec,c)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c9950419.lfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c9950419.lfilter(c,mg)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLinkSummonable(mg,nil,2,2)
end
function c9950419.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9950419.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9950419.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950419.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) then
		local mg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9950419.lfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local lc=g:GetFirst()
		if lc then
			Duel.LinkSummon(tp,lc,mg,nil,2,2)
		end
	end
end
