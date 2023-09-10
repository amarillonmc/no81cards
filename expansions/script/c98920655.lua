--铁兽战线 救援之奥尔
function c98920655.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST),2,3)
	c:EnableReviveLimit()
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920655,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,98920655)
	e1:SetTarget(c98920655.sptg)
	e1:SetOperation(c98920655.spop)
	c:RegisterEffect(e1)
	  --tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920655,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,98930655)
	e4:SetTarget(c98920655.thtg)
	e4:SetOperation(c98920655.thop)
	c:RegisterEffect(e4)
end
function c98920655.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dg=Duel.GetMatchingGroup(c98920655.tdfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chkc then return false end
	if chk==0 then return dg:CheckSubGroup(c98920655.fselect,2,2,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=dg:SelectSubGroup(tp,c98920655.fselect,false,2,2,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98920655.tdfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e) and c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST)
		and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c98920655.fselect(g,e,tp)
	return aux.drccheck(g) and g:IsExists(Card.IsAbleToHand,2,nil) and g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false)
end
function c98920655.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920655.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=tg:FilterSelect(tp,c98920655.spfilter,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			tg:Sub(sg)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920655.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920655.splimit(e,c)
	return not c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST)
end
function c98920655.thfilter(c)
	return c:IsSetCard(0x14d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920655.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c98920655.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920655.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98920655.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98920655.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end