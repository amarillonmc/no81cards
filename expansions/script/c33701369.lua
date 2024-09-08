--[[
缝合怪融合
Amalgamate Fusion
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[Pay half your LP; reveal 1 non-Effect Fusion Monster in your Extra Deck, then send Fusion Materials mentioned on it from your hand and/or Deck to the GY,
	then send the same number of monsters with the same Attribute and Type from your Deck to the GY, and if you do, Fusion Summon the revealed monster, then choose 1 of the following effects
	to apply (you can also halve your LP to apply both effects, in sequence):
	● The Fusion Summoned monster's ATK/DEF becomes the total ATK/DEF of the non-Fusion Materials sent to the GY by this card's effect.
	● The Fusion Summoned monster gains the original effects of the non-Fusion Materials sent to the GY by this card's effect.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_FUSION_SUMMON|CATEGORY_TOGRAVE|CATEGORIES_ATKDEF)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(nil,aux.PayHalfLPCost,s.target,s.activate)
	c:RegisterEffect(e1)
end
s.fusion_effect=true

function s.tgfilter(c)
	return c:IsMonster() and c:IsAbleToGrave()
end
function s.filter0(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsLocation(LOCATION_HAND)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and not c:IsType(TYPE_EFFECT) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.revealonly(c)
	return c:IsType(TYPE_FUSION) and not c:IsType(TYPE_EFFECT)
end
function s.fcheck(tg)
	return	function(tp,sg,fc)
				return tg:IsExists(Card.IsAttributeRace,#sg,nil,fc:GetAttribute(),fc:GetRace())
			end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tg=Duel.Group(s.tgfilter,tp,LOCATION_DECK,0,nil)
		if #tg<=0 then return false end
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
		local mg2=Duel.Group(s.filter0,tp,LOCATION_DECK,0,nil,e)
		mg1:Merge(mg2)
		aux.FCheckAdditional=s.fcheck(tg)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil,e)
	mg1:Merge(mg2)
	local tg=Duel.Group(s.tgfilter,tp,LOCATION_DECK,0,nil)
	aux.FCheckAdditional=s.fcheck(tg)
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local ResolutionCheckpoint=0
	if #sg1==0 then
		ResolutionCheckpoint=1
		aux.FCheckAdditional=nil
		sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		if #sg1==0 then
			ResolutionCheckpoint=2
			sg1=Duel.GetMatchingGroup(s.revealonly,tp,LOCATION_EXTRA,0,nil)
		end
	end
	if #sg1>0 then
		local sg=sg1:Clone()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local fg=sg:Select(tp,1,1,nil)
		local tc=fg:GetFirst()
		if tc then
			Duel.ConfirmCards(1-tp,fg)
			if ResolutionCheckpoint<=1 then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				if Duel.SendtoGrave(mat1,REASON_EFFECT|REASON_MATERIAL|REASON_FUSION)>0 and ResolutionCheckpoint<=0 then
					local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
					if ct>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
						local tg2=tg:FilterSelect(tp,Card.IsAttributeRace,ct,ct,nil,tc:GetAttribute(),tc:GetRace())
						if #tg2>0 then
							Duel.BreakEffect()
							if Duel.SendtoGraveAndCheck(tg2) then
								local nonmats=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
								if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)>0 then
									tc:CompleteProcedure()
									if #nonmats>0 then
										local atk=nonmats:GetSum(Card.GetAttack)
										local def=nonmats:GetSum(Card.GetDefense)
										local b1=tc:IsCanChangeStats(atk,def,e,tp,REASON_EFFECT)
										local b2=nonmats:IsExists(Card.IsOriginalType,1,nil,TYPE_EFFECT)
										local opt=0
										if not b1 and not b2 then
											return
										elseif b1 and b2 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
											Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
											opt=3
										else
											opt=1<<aux.Option(tp,id,2,b1,b2)
										end
										if opt&1==1 then
											Duel.BreakEffect()
											tc:ChangeATKDEF(atk,def,true,{c,true})
										end
										if opt&2==2 then
											Duel.BreakEffect()
											for nc in aux.Next(nonmats) do
												local code=nc:GetOriginalCodeRule()
												tc:CopyEffect(code,RESET_EVENT|RESETS_STANDARD)
											end
											tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	aux.FCheckAdditional=nil
end