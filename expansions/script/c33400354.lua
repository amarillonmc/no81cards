--夜刀神-孤独
function c33400354.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33400354.target)
	e1:SetOperation(c33400354.activate)
	c:RegisterEffect(e1)
	 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1,33400354)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c33400354.thcon)
	e2:SetTarget(c33400354.thtg)
	e2:SetOperation(c33400354.thop)
	c:RegisterEffect(e2)
end
function c33400354.exfilter0(c)
	return c:IsSetCard(0x341) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c33400354.filter(c,e,tp)
	return c:IsSetCard(0x341) 
end
function c33400354.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)<=1
end
function c33400354.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)<=1
end
function c33400354.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=nil
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  then
			sg=Duel.GetMatchingGroup(c33400354.exfilter0,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)
		end
		aux.RCheckAdditional=c33400354.rcheck
		aux.RGCheckAdditional=c33400354.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c33400354.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
		 aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c33400354.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local sg=nil
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		 sg=Duel.GetMatchingGroup(c33400354.exfilter0,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)
	end
	aux.RCheckAdditional=c33400354.rcheck
	aux.RGCheckAdditional=c33400354.rgcheck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c33400354.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg  then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)
		if mat2:GetCount()>0 then
			mat:Sub(mat2)
			Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat) 
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
  aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end

function c33400354.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and not c:IsType(TYPE_NORMAL)
end
function c33400354.thcon(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsSetCard(0x341) and rc:IsType(TYPE_RITUAL) and rc:IsControler(tp) 
end
function c33400354.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c33400354.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
