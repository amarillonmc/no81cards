--混合体升华
local m=30005512
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 0
	local e01=Effect.CreateEffect(c)
	e01:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e01:SetType(EFFECT_TYPE_ACTIVATE)
	e01:SetCode(EVENT_FREE_CHAIN)
	e01:SetOperation(cm.activate)
	c:RegisterEffect(e01)
	--Effect 1  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2)
	e2:SetTarget(cm.ttg)
	e2:SetOperation(cm.top)
	c:RegisterEffect(e2)
	--Effect 2
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.ftg)
	e1:SetOperation(cm.fop)
	c:RegisterEffect(e1) 
end
--Effect 1
function cm.spf(c,fc,e,tp)
	return (aux.IsMaterialListCode(fc,c:GetCode()) or aux.IsCodeListed(fc,c:GetCode())) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToHand())
end
function cm.cff(c,e,tp)
	local b1=c:IsFaceup() and c:IsLocation(LOCATION_MZONE) 
	local b2=c:IsCanBeEffectTarget(e)
	local b3=c:IsSummonType(SUMMON_TYPE_FUSION)
	local b4=Duel.IsExistingMatchingCard(cm.spf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c,e,tp)
	return b1 and b2 and b3 and b4 
end
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) end
	if chk==0 then return eg:IsExists(cm.cff,1,nil,e,tp) end
	local dg=eg
	if #eg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		dg=eg:FilterSelect(tp,cm.cff,1,1,nil,e,tp)
	end
	Duel.SetTargetCard(dg)
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local tcc=Duel.GetFirstTarget()
	if tcc:IsRelateToEffect(e) and tcc:IsFaceup() 
		and tcc:IsLocation(LOCATION_MZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spf),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tcc,e,tp):GetFirst()
		if not tc or tc==nil then return false end
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=aux.SelectFromOptions(tp,{b1,1190},{b2,1152})
		if op==1 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		if op==2 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--Effect 2 
function cm.suf(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x927) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function cm.ppf(c,e,tp,g)
	return c:IsCode(30005503) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) 
		and (g==nil or Duel.GetLocationCountFromEx(tp,tp,g,c)>0)
end
function cm.ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED 
	local g=Duel.GetMatchingGroup(cm.suf,tp,loc,0,nil,e,tp)
	local b1=aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
	local b2=g:GetClassCount(Card.GetCode)>=7
	local b3=Duel.IsExistingMatchingCard(cm.ppf,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil)
	if chk==0 then return b1 and b2 and b3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,loc)
end
function cm.fop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED 
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.suf),tp,loc,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if g:GetClassCount(Card.GetCode)<7 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,7,7)
	if #sg>=6 then
		if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,cm.ppf,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg)
			local tc=tg:GetFirst()
			if tc then
				tc:SetMaterial(sg)
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end

