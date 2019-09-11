--荒碑守 望川
local m=14000382
local cm=_G["c"..m]
cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.Grava(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Gravalond or c:IsCode(14000380))
end
function cm.spfilter(c)
	return c:IsCode(14000380) and c:IsPreviousLocation(LOCATION_DECK)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.spfilter,1,nil) and (c:IsLocation(LOCATION_GRAVE) or Duel.IsPlayerAffectedByEffect(tp,14000386))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local loc=c:GetLocation()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,loc)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
end
function cm.sfilter(c,e,tp)
	return cm.Grava(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)==0 or not g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then return end
		local g=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_GRAVE,0,c,e,tp)
		local mg=g:Filter(cm.ffilter,nil,e)
		mg:AddCard(c)
		if mg:GetCount()<2 or Duel.GetLocationCountFromEx(tp,tp,c)<=0 then return end
		local sg=Duel.GetMatchingGroup(cm.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,c)
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local mat=mg:FilterSelect(tp,cm.ffilter3,1,1,c,e,tp,c)
			local tc=mat:GetFirst()
			if tc then
				if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local fc=sg:Select(tp,1,1,nil):GetFirst()
					mat:AddCard(c)
					fc:SetMaterial(mg)
					Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_FUSION+REASON_EFFECT)
					Duel.BreakEffect()
					Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
					fc:CompleteProcedure()
				end
			end
		end
	end
end
function cm.ffilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.ffilter2(c,e,tp,mg,gc)
	return cm.Grava(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,gc)
end
function cm.ffilter3(c,e,tp,gc)
	local mg=Group.FromCards(c,gc)
	return Duel.IsExistingMatchingCard(cm.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,gc)
end