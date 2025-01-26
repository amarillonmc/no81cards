--判决牢狱的囚犯 05桐崎狮童
function c19209525.initial_effect(c)
	aux.AddCodeList(c,19209511)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum effect
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,19209525)
	e1:SetCondition(c19209525.thcon)
	e1:SetTarget(c19209525.thtg)
	e1:SetOperation(c19209525.thop)
	c:RegisterEffect(e1)
	--monster effect
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19209526)
	e2:SetTarget(c19209525.tgtg)
	e2:SetOperation(c19209525.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,19209527)
	e4:SetTarget(c19209525.sptg)
	e4:SetOperation(c19209525.spop)
	c:RegisterEffect(e4)
end
function c19209525.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),19209511)
end
function c19209525.thfilter(c)
	return c:IsCode(19209548) and c:IsAbleToHand()
end
function c19209525.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209525.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19209525.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209525.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c19209525.tgfilter(c,e,p)
	return c:IsFaceup() and c:IsAbleToGrave() and Duel.GetMZoneCount(p,c)>0
		and Duel.IsExistingMatchingCard(c19209525.spfilter,p,LOCATION_GRAVE,0,1,nil,e,p,c:GetCode())
end
function c19209525.spfilter(c,e,p,code)
	return not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEUP_DEFENSE)
end
function c19209525.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209525.tgfilter,tp,0,LOCATION_MZONE,1,nil,e,1-tp) and Duel.IsPlayerCanDraw(1-tp,1) end
	local g=Duel.GetMatchingGroup(c19209525.tgfilter,tp,0,LOCATION_MZONE,nil,e,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c19209525.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c19209525.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,e,1-tp):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local p=1-tp
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(p,c19209525.spfilter,p,LOCATION_GRAVE,0,1,1,nil,e,p,tc:GetCode()):GetFirst()
		if Duel.SpecialSummon(sc,0,p,p,false,false,POS_FACEUP_DEFENSE)~=0 and Duel.IsPlayerCanDraw(p,1) then
			Duel.BreakEffect()
			Duel.Draw(p,1,REASON_EFFECT)
		end
	end
end
function c19209525.spfilter2(c,e,tp)
	return c:IsSetCard(0x3b50) and not c:IsCode(19209525) and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19209525.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c19209525.spfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c19209525.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c19209525.spfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(2,ft))
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
