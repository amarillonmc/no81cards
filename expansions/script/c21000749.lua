--仪式编织者的暗之种
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.prop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,id+o)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.prop2)
	c:RegisterEffect(e3)
end

function s.filter(c,e,tp)
	return c:IsSetCard(0x619) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function s.matfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x619)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(s.matfilter,nil)
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
				if tc:IsAbleToHand() and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_HAND+LOCATION_DECK,0,2,nil) then
					Duel.BreakEffect()
					local result = Duel.SelectYesNo(tp,aux.Stringid(id,5))
					if not result then return end

					local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
					local tc=g1:GetFirst()
					if tc then
						mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat=mg:Select(tp,1,2,tc)
						if not mat or mat:GetCount()==0 then return end
						tc:SetMaterial(mat)
						Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
						Duel.BreakEffect()
						Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
						tc:CompleteProcedure()
					end
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

	if tc:IsCode(ac) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	elseif tc:IsAbleToRemove(tp) then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
	end

end