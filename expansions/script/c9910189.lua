--追缉队致命一击
function c9910189.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9910189)
	e2:SetTarget(c9910189.thtg)
	e2:SetOperation(c9910189.thop)
	c:RegisterEffect(e2)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9910190)
	e3:SetTarget(c9910189.rltg)
	e3:SetOperation(c9910189.rlop)
	c:RegisterEffect(e3)
end
function c9910189.thfilter(c)
	return c:IsSetCard(0x3954) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c9910189.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910189.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c9910189.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910189.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	end
end
function c9910189.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	if chk==0 then return a and d and a:IsSetCard(0x3954) and (a:IsReleasableByEffect() or d:IsReleasableByEffect()) end
	local g=Group.CreateGroup()
	if a:IsRelateToBattle() then g:AddCard(a) end
	if d:IsRelateToBattle() then g:AddCard(d) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0)
end
function c9910189.spfilter(c,e,tp,lp)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsRace(RACE_WARRIOR)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	return lp>c:GetLevel()*300
end
function c9910189.rlop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	local rg=g:Filter(Card.IsRelateToBattle,nil)
	if #rg==0 or Duel.Release(rg,REASON_EFFECT)==0 then return end
	local lp=Duel.GetLP(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9910189.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,lp)
		and Duel.SelectYesNo(tp,aux.Stringid(9910189,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c9910189.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lp)
		local tc=tg:GetFirst()
		if tc then
			Duel.PayLPCost(tp,tc:GetLevel()*300)
			tc:SetMaterial(nil)
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
