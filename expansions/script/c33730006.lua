--键★等 －梦幻聚首 | K.E.Y Etc. Connessione
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.tgfilter(c,e,tp,sg)
	if not c:IsSetCard(0x460) or not c:IsType(TYPE_MONSTER) or not c:IsAbleToGrave() then return false end
	sg:AddCard(c)
	local res=(#sg>1) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,sg,e,tp,sg) or Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,sg,e,tp,sg)
	sg:RemoveCard(c)
	return res
end
function s.spfilter(c,e,tp,sg)
	return c:IsSetCard(0x5460) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,sg,c)>0
end
function s.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sg=Group.CreateGroup()
		local res=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),e,tp,sg)
		sg:DeleteGroup()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp,sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,g1,e,tp,sg)
	g1:Merge(g2)
	sg:DeleteGroup()
	if #g1>=2 and Duel.SendtoGrave(g1,REASON_EFFECT)>0 and g1:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
		if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)>0 then
			local sc=sg:GetFirst()
			if sc:IsType(TYPE_XYZ) then
				local og=g1:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(Card.IsCanOverlay,nil)
				if #og>0 then
					Duel.Overlay(sc,og)
				end
			end
			local spg=Duel.GetMatchingGroup(s.spfilter2,tp,0,LOCATION_EXTRA,nil,e,tp)
			if #spg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				local spc=spg:Select(1-tp,1,1,nil):GetFirst()
				if spc then
					Duel.SpecialSummon(spc,0,1-tp,1-tp,true,false,POS_FACEUP)
				end
			end
		end
	end
end