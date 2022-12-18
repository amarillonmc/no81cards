--人理之基 灰姑娘伊丽莎白
function c22022440.initial_effect(c)
	aux.AddCodeList(c,22020850)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xff1),c22022440.matfilter,true)
	--choose effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022440,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22022440)
	e1:SetTarget(c22022440.target)
	e1:SetOperation(c22022440.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022440,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22022441)
	e2:SetTarget(c22022440.sptg)
	e2:SetOperation(c22022440.spop)
	c:RegisterEffect(e2)
end
function c22022440.matfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c22022440.tgfilter(c,e,tp,ec,spchk)
	return c:IsControlerCanBeChanged() or c:IsAbleToGrave()
end
function c22022440.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c22022440.tgfilter(chkc,e,tp,c,spchk) end
	if chk==0 then return Duel.IsExistingTarget(c22022440.tgfilter,tp,0,LOCATION_MZONE,1,nil,e,tp,c,spchk) end
	Duel.SelectOption(tp,aux.Stringid(22022440,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22022440.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp,c,spchk)
end
function c22022440.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local b1=tc:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControlerCanBeChanged() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=tc:IsRelateToEffect(e) and tc:IsAbleToGrave() 
	if b1 or b2 then
		local s
		if b1 and b2 then
			s=Duel.SelectOption(1-tp,aux.Stringid(22022440,1),aux.Stringid(22022440,2))
		elseif b1 then
			s=Duel.SelectOption(tp,aux.Stringid(22022440,1))
		else
			s=Duel.SelectOption(tp,aux.Stringid(22022440,2))+1
		end
		if s==0 then
			Duel.Hint(HINT_CARD,0,22022440)
			Duel.SelectOption(tp,aux.Stringid(22022440,4))
			Duel.GetControl(tc,tp)
		end
		if s==1 then
			Duel.Hint(HINT_CARD,0,22020880)
			Duel.SelectOption(tp,aux.Stringid(22022440,5))
			Duel.SelectOption(tp,aux.Stringid(22022440,6))
			Duel.SelectOption(tp,aux.Stringid(22022440,7))
			Duel.SendtoGrave(tc,REASON_EFFECT)
			Duel.Damage(1-tp,2400,REASON_EFFECT)
		end
	end
end
function c22022440.thfilter(c,tp)
	return c:IsFaceup() and (c:IsCode(22020850) or aux.IsCodeListed(c,22020850)) and c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c)
end
function c22022440.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22022440.thfilter(chkc,tp) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c22022440.thfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c22022440.thfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22022440.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and c:IsRelateToEffect(e) then
		Duel.SelectOption(tp,aux.Stringid(22022440,8))
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
