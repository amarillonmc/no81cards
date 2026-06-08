local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--Ritual Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.rittg)
	e1:SetOperation(s.ritop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.matfilter(c)
	local is_mon=false
	if c:IsLocation(LOCATION_SZONE) then
		is_mon=(c:GetOriginalType()&TYPE_MONSTER)~=0
	else
		is_mon=c:IsType(TYPE_MONSTER)
	end
	return is_mon and c:IsReleasableByEffect() and c:GetOriginalLevel()>0
end
function s.ritfilter(c,e,tp,m)
	if not (c:IsCode(id+8) and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) then return false end
	local mg=m:Clone()
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	return mg:CheckSubGroup(s.fselect,1,10,tp,c,10)
end
function s.fselect(g,tp,c,lv)
	local b1=false
	if c:IsLocation(LOCATION_EXTRA) then
		b1=Duel.GetLocationCountFromEx(tp,tp,g,c)>0
	else
		b1=Duel.GetMZoneCount(tp,g,tp)>0
	end
	if not b1 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetOriginalLevel,lv)
end
function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local m=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		return Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,m)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.ritfilter),tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,m)
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Clone()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectSubGroup(tp,s.fselect,true,1,10,tp,tc,10)
		if mat then
			tc:SetMaterial(mat)
			Duel.Release(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
			Duel.BreakEffect()
			if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
				tc:CompleteProcedure()
				local ct=math.min(5,Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0))
				if ct>0 then
					local g=Duel.GetDecktopGroup(1-tp,ct)
					Duel.ConfirmCards(tp,g)
				end
			end
		end
	end
end
function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousTypeOnField()&(TYPE_SPELL+TYPE_TRAP)~=0
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
