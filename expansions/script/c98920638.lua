--光道主教 普纽玛
function c98920638.initial_effect(c)
	 --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920638)
	e1:SetTarget(c98920638.sptg)
	e1:SetOperation(c98920638.spop)
	c:RegisterEffect(e1)
	 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920638,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920638.tdcon)
	e2:SetTarget(c98920638.tdtg)
	e2:SetOperation(c98920638.tdop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3) 
	--discard deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920638,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)   
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c98920638.discon)
	e4:SetTarget(c98920638.distg)
	e4:SetOperation(c98920638.disop)
	c:RegisterEffect(e4)
end
function c98920638.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp):Filter(c98920638.rfilter,nil,tp)
	if chk==0 then return g:CheckSubGroup(c98920638.fselect,1,g:GetCount(),tp) 
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920638.rfilter(c,tp)
	return c:IsLevelAbove(1) and (c:IsControler(tp) or c:IsFaceup())
end
function c98920638.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,7) and aux.mzctcheckrel(g,tp)
end
function c98920638.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp):Filter(c98920638.rfilter,nil,tp)
	if not g:CheckSubGroup(c98920638.fselect,1,g:GetCount(),tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,c98920638.fselect,false,1,g:GetCount(),tp)
	aux.UseExtraReleaseCount(rg,tp)
	Duel.Release(rg,REASON_EFFECT+REASON_RITUAL)
	c:SetMaterial(rg)
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	c:CompleteProcedure()
end
function c98920638.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x38)
end
function c98920638.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920638.tgfilter,1,nil,tp)
end
function c98920638.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c98920638.chfilter,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98920638.chfilter(c)
	return c:IsSetCard(0x38) and c:IsAbleToHand()
end
function c98920638.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c98920638.chfilter,nil,tp)
	local mg=g:Filter(aux.NecroValleyFilter(Card.IsRelateToChain),nil)
	if #mg>0 and c:IsRelateToChain() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local og=mg:Select(tp,1,1,nil)
		Duel.SendtoHand(og,tp,REASON_EFFECT)
	end
end
function c98920638.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c98920638.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c98920638.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end