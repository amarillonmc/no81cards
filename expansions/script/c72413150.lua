--冰晶光芒 莉莉
function c72413150.initial_effect(c)
		--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72413150,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,72413150)
	e1:SetTarget(c72413150.thtg)
	e1:SetOperation(c72413150.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
		--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72413150,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,72413151)
	e3:SetCondition(c72413150.spcon)
	e3:SetTarget(c72413150.sptg)
	e3:SetOperation(c72413150.spop)
	c:RegisterEffect(e3)
	if not c72413150.global_check then
		c72413150.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetCondition(c72413150.regcon)
		ge1:SetOperation(c72413150.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
--
function c72413150.regcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE)~=0
end
function c72413150.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	Duel.RegisterFlagEffect(c:GetControler(),72413150,RESET_PHASE+PHASE_END,0,1)
end
--
function c72413150.thfilter(c)
	return c:IsSetCard(0x5727) and not c:IsCode(72413150) and c:IsAbleToHand()
end
function c72413150.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72413150.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function c72413150.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72413150.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
end
--
function c72413150.scfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSynchroSummonable(nil)
end
function c72413150.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),72413150)==0
end
function c72413150.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c72413150.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0  and Duel.IsExistingMatchingCard(c72413150.scfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(72413150,0)) then
			local g2=Duel.GetMatchingGroup(c72413150.scfilter,tp,LOCATION_EXTRA,0,nil)
			if g2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
			end
		end
	end
end