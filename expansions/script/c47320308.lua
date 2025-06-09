-- 失梦之咒
local s,id=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,47320301)
    s.ritual(c)
    s.tohand(c)
end
function s.ritual(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.rittg)
    e1:SetOperation(s.ritop)
    c:RegisterEffect(e1)
end
function s.mfilter(c)
	return c:GetLevel()>0 and (c:IsSetCard(0x3c17) and c:IsType(TYPE_RITUAL) or aux.IsCodeListed(c,47320301)) and c:IsReleasable(REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL)
end
function s.rcheck(tp,g,c)
    local dg=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return dg:GetCount()<2
end
function s.rgcheck(g,ec)
	local dg=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return dg:GetCount()<2
end
function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_DECK,0,nil)
	if Duel.GetFlagEffect(tp,47320308)~=0 then mg2:Clear() end
	aux.RCheckAdditional=s.rcheck
	aux.RGCheckAdditional=s.rgcheck
	local s1=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,nil,e,tp,mg1,mg2,Card.GetLevel,"Equal")
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	if chk==0 then return s1 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	aux.RCheckAdditional=s.rcheck
	aux.RGCheckAdditional=s.rgcheck
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_DECK,0,nil)
	if Duel.GetFlagEffect(tp,47320308)~=0 then mg2:Clear() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,s.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			goto cancel
		end
		tc:SetMaterial(mat)
		local ct=mat:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		Duel.ReleaseRitualMaterial(mat)
		if ct>0 then
			Duel.RegisterFlagEffect(tp,47320308,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
function s.tohand(c)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id-1000)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end
function s.thfilter(c)
    return c:IsSetCard(0x3c17) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,c) and c:IsAbleToHand() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
        local g=Group.FromCards(tc,c)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

