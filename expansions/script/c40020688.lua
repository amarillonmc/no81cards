--宙斯的仪式神殿
local s, id = GetID()
s.named_with_EmperorBeast = 1
function s.EmperorBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end
s.ZEUS_CODE = 40020683
function s.initial_effect(c)
	aux.AddCodeList(c,40020683)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id+20)
	e2:SetTarget(s.rittg)
	e2:SetOperation(s.ritop)
	c:RegisterEffect(e2)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE + PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1, id+1)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.zeusfilter(c)
	return c:GetCode() == s.ZEUS_CODE
end

function s.ritfilter(c)
	return s.EmperorBeast(c)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)

	if Duel.IsExistingMatchingCard(s.zeusfilter,tp,LOCATION_DECK,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.zeusfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end

function s.matfilter(c)
	return c:IsReleasable() and c:GetLevel()>0
end

function s.ritfilter(c,e,tp,mg)
	if not (s.EmperorBeast(c) and c:IsType(TYPE_RITUAL)) then return false end
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local lv=c:GetLevel()
	return mg:CheckSubGroup(s.fselect,1,#mg,lv,tp)
end

function s.fselect(g,lv,tp)
	if g:GetSum(Card.GetLevel)~=lv then return false end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
	end
	return true
end

function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_DECK,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end

function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,s.ritfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectSubGroup(tp,s.fselect,false,1,#mg,lv,tp)
		if not mat or #mat==0 then return end
		tc:SetMaterial(mat)
		Duel.Release(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
		end
	end
end

function s.recfilter(c)
	return s.EmperorBeast(c) or c:IsCode(40020683)
end
function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() == tp
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then 
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.recfilter(chkc) 
	end
	if chk == 0 then 
		return Duel.IsExistingTarget(s.recfilter, tp, LOCATION_GRAVE, 0, 1, nil) 
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectTarget(tp, s.recfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	
	local hasPendulumZone = Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)
	
	local isPendulum = tc:IsType(TYPE_PENDULUM)
	
	if hasPendulumZone and isPendulum then
		local op = Duel.SelectOption(tp, aux.Stringid(id, 4), aux.Stringid(id, 5))
		if op == 0 then

			Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
			return
		end
	end
	
	Duel.SendtoHand(tc, nil, REASON_EFFECT)
	Duel.ConfirmCards(1 - tp, tc)
end