--漆黑之片羽 - 与暗之堕落天使之神圣契约
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target3)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.prop2)
	c:RegisterEffect(e2)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x619)
end
function s.mfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x619) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,s.filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mfilter),tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,s.filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	
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
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(Card.IsSetCard,nil,0x619)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		if Duel.SendtoDeck(mat2,nil,nil,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)>0 then
			Duel.ShuffleDeck(tp)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end


function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetDecktopGroup(tp,5)
		return g:FilterCount(Card.IsAbleToHand,nil)>0 
	end
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac1=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac2=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac3=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac4=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac5=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	e:SetOperation(s.prop3(ac1,ac2,ac3,ac4,ac5))
end

function s.filter0(c,e,tp)
	return c:IsSetCard(0x619) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function s.hfilter(c,code1,code2,code3,code4,code5)
	return c:IsCode(code1,code2,code3,code4,code5)
end
function s.prop3(code1,code2,code3,code4,code5)
	return
		function (e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			Duel.ConfirmDecktop(tp,5)
			local g=Duel.GetDecktopGroup(tp,5)
			local hg=g:Filter(s.hfilter,nil,code1,code2,code3,code4,code5)
			if hg:GetCount()==g:GetCount() then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tc=hg:Select(tp,1,1,nil):GetFirst()
				if tc:IsAbleToHand() then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
					Duel.ShuffleHand(tp)
					
					Duel.BreakEffect()
					
					if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter0),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then return end
					local result = Duel.SelectYesNo(tp,aux.Stringid(id,5))
					if not result then return end
					
					local ft0 = Duel.GetLocationCount(tp,LOCATION_MZONE)
					if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft0=1 end
					local checktg = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter0),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ft0,nil,e,tp)
					tc=checktg:GetFirst()
					while tc do
						local tcg = Group.CreateGroup()
						tcg:AddCard(tc)
						tc:SetMaterial(tcg)
						Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
						tc:CompleteProcedure()
						tc=checktg:GetNext()
					end
					Duel.SpecialSummonComplete()
				end
			else
				Duel.ShuffleDeck(tp)
				
				local lp=Duel.GetLP(tp)
				Duel.SetLP(tp,lp-600000)
			end
		end
end

function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	
	local c=e:GetHandler()
	g:AddCard(c)

	if tc:IsCode(ac) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	elseif tc:IsAbleToRemove(tp) then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
	end

end