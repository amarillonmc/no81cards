--[[
砂之星之回忆
Memories of the Sandstar
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[Apply 1 of these effects.
	● Ritual Summon 1 "Anifriends" Ritual Monster from your hand or GY, by Tributing "Anifriends" monsters with different names from your hand and/or field, whose total Levels exactly equal the Level
	of the Ritual Monster.
	● Special Summon, from your Deck or Extra Deck, 1 "Anifriends" monster with a Level equal to or lower than the number of monster effects of "Anifriends" monsters with different names that you
	activated this turn, and if you do, send this card to the GY, then skip to your opponent's next Draw Phase. ]]
	local rtg=aux.RitualUltimateTarget(s.rfilter,Card.GetLevel,"Equal",LOCATION_HAND|LOCATION_GRAVE,nil,s.rfilter)
	local rop=aux.RitualUltimateOperation(s.rfilter,Card.GetLevel,"Equal",LOCATION_HAND|LOCATION_GRAVE,nil,s.rfilter)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TOGRAVE|CATEGORY_DECKDES|CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(
		nil,
		nil,
		s.target(rtg),
		s.activate(rtg,rop)
	)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s.ActivatedAnifriendsCodes={{},{}}
		s.ActivatedAnifriendsCodesCount={0,0}
		aux.RegisterTriggeringArchetypeCheck(c,ARCHE_ANIFRIENDS)
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_CHAIN_SOLVING)
		ge:SetOperation(s.regop)
		Duel.RegisterEffect(ge,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_TURN_END)
		ge2:OPT()
		ge2:SetOperation(s.resetop)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) or not aux.CheckArchetypeReasonEffect(s,re,ARCHE_ANIFRIENDS) then return end
	local mustUpdate=false
	local p=ep+1
	local tab=s.ActivatedAnifriendsCodes[p]
	local code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	if tab[code1]==nil then
		mustUpdate=true
		tab[code1]=true
	end
	if code2 and code2~=0 and tab[code2]==nil then
		mustUpdate=true
		tab[code2]=true
	end
	if mustUpdate then
		s.ActivatedAnifriendsCodesCount[p]=s.ActivatedAnifriendsCodesCount[p]+1
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	for p=1,2 do
		aux.ClearTableRecursive(s.ActivatedAnifriendsCodes[p])
		s.ActivatedAnifriendsCodesCount[p]=0
	end
end

--E1
function s.rfilter(c)
	return c:IsSetCard(ARCHE_ANIFRIENDS)
end
function s.spfilter(c,e,tp,ct)
	return c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsLevelBelow(ct) and Duel.GetMZoneCountFromLocation(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(rtg)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local ct=s.ActivatedAnifriendsCodesCount[tp+1]
					aux.RGCheckAdditional=aux.dncheck
					local res=rtg(e,tp,eg,ep,ev,re,r,rp,0) or (ct>0 and Duel.IsExists(false,s.spfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,nil,e,tp,ct))
					aux.RGCheckAdditional=nil
					return res
				end
				Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK|LOCATION_EXTRA)
				Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
			end
end
function s.activate(rtg,rop)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local ct=s.ActivatedAnifriendsCodesCount[tp+1]
				aux.RGCheckAdditional=aux.dncheck
				local b1=rtg(e,tp,eg,ep,ev,re,r,rp,0)
				local b2=ct>0 and Duel.IsExists(false,s.spfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,nil,e,tp,ct)
				if not b1 and not b2 then
					aux.RGCheckAdditional=nil
					return
				end
				local opt=aux.Option(tp,id,1,b1,b2)
				if opt==0 then
					rop(e,tp,eg,ep,ev,re,r,rp)
				elseif opt==1 then
					local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,s.spfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,1,nil,e,tp,ct)
					if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
						local c=e:GetHandler()
						if c:IsRelateToChain() and Duel.SendtoGraveAndCheck(c,nil,REASON_EFFECT) then
							Duel.BreakEffect()
							local p=Duel.GetTurnPlayer()
							Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
							Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
							Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
							Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE|PHASE_END,1)
							Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
							Duel.SkipPhase(p,PHASE_END,RESET_PHASE|PHASE_END,1)
							if p==1-tp then
								local e1=Effect.CreateEffect(c)
								e1:SetType(EFFECT_TYPE_FIELD)
								e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
								e1:SetCode(EFFECT_SKIP_TURN)
								e1:SetTargetRange(1,0)
								e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN)
								Duel.RegisterEffect(e1,tp)
							end
							local e2=Effect.CreateEffect(c)
							e2:SetType(EFFECT_TYPE_FIELD)
							e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
							e2:SetCode(EFFECT_CANNOT_EP)
							e2:SetAbsoluteRange(p,1,0)
							e2:SetReset(RESET_PHASE|PHASE_END)
							Duel.RegisterEffect(e2,tp)
						end
					end
				end
				aux.RGCheckAdditional=nil
			end
end