--仪式编织者的暗之种
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.thtg)
	e0:SetOperation(s.thop)
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
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.prop2)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c:IsSetCard(0x619) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_SPELL))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)

	if tc:IsCode(ac) and tc:IsAbleToHand() and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ShuffleHand(tp)
		
		Duel.BreakEffect()
		
		if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then
			local result = Duel.SelectYesNo(tp,aux.Stringid(id,4))
			if not result then return end

			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 then
				Duel.ConfirmCards(1-tp,g1)
				Duel.ShuffleDeck(tp)
				Duel.ShuffleHand(tp)
			end
		end
	elseif tc:IsAbleToRemove(tp) then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
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
	return c:IsSetCard(0x619) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and c:IsType(TYPE_RITUAL)
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
				if tc:IsAbleToHand() and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
					Duel.ConfirmCards(1-tp,tc)
					Duel.ShuffleHand(tp)
					
					Duel.BreakEffect()
					
					if not Duel.SelectYesNo(tp,aux.Stringid(id,5)) then return end
					
					local mg1=Duel.GetRitualMaterial(tp)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g0=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,1,nil,s.filter,e,tp,mg1,nil,Card.GetLevel,"Greater")
					local tc0=g0:GetFirst()
					
					if tc0 then 
						local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc0,tc0)
						if tc0.mat_filter then
							mg=mg:Filter(tc0.mat_filter,tc,tp)
						else
							mg:RemoveCard(tc0)
						end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc0:GetLevel(),"Greater")
						local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc0:GetLevel(),tp,tc0,tc0:GetLevel(),"Greater")
						aux.GCheckAdditional=nil
						if not mat or mat:GetCount()==0 then return end
						tc0:SetMaterial(mat)
						Duel.ReleaseRitualMaterial(mat)
						Duel.BreakEffect()
						Duel.SpecialSummon(tc0,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
						tc0:CompleteProcedure()
					end
				end
			else
				Duel.ShuffleDeck(tp)
				
				local lp=Duel.GetLP(tp)
				Duel.SetLP(tp,0)
			end
		end
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x619)
end
function s.mfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x619) and c:IsAbleToDeck()
end

function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return  c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end