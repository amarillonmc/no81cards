--レアル・ジェネクス・バリア
local s,id,o=GetID()
function s.initial_effect(c)
	--
	if c:GetOriginalCode()==id then

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	e2:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	c:RegisterEffect(e2)
	--cost change
	--adjust
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)

	end
end
function s.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() or Duel.GetFlagEffect(tp,id)~=0 end
	if Duel.GetFlagEffect(tp,id)==0 then
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end
end
function s.spfilter1(c,e,tp)
	return c:IsCode(68505803) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function s.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x2)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil,tp,lv)
end
function s.filter2(c,tp,lv)
	local rlv=lv-c:GetOriginalLevel()
	local rg=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_MZONE,0,c)
	return rlv>0 and c:IsType(TYPE_TUNER) and c:IsSetCard(0x2) and c:IsAbleToGrave()
		and rg:CheckWithSumEqual(Card.GetOriginalLevel,rlv,1,63)
end
function s.filter3(c)
	return c:GetOriginalLevel()>0 and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local lv=g1:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil,tp,lv)
		local rlv=lv-g2:GetFirst():GetOriginalLevel()
		local rg=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_MZONE,0,g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetOriginalLevel,rlv,1,63)
		g2:Merge(g3)
		Duel.SendtoGrave(g2,REASON_EFFECT)
		g1:GetFirst():SetMaterial(nil)
		Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		g1:GetFirst():CompleteProcedure()
	end
end

----------------cost change---------------

function s.filter(c)
	return c:IsSetCard(0x2) and c:GetOriginalCode()~=id and c:IsType(TYPE_MONSTER)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil)

		--get discard effect
		Genex_cregister=Card.RegisterEffect
		cisdiscardable=Card.IsDiscardable
		cisabletograveascost=Card.IsAbleToGraveAsCost
		disexitingmatchingcard=Duel.IsExistingMatchingCard
		esetrange=Effect.SetRange
		Genex_effect_range={}
		Card.IsDiscardable=function(card,reason)
			Genex_discard_effect_c=card
			Genex_discard_effect_check=true
			return true
		end
		Card.IsAbleToGraveAsCost=function(card)
			Genex_discard_effect_c=card
			Genex_discard_effect_check=true
			return true
		end
		Duel.IsExistingMatchingCard=function(filter,player,s,o,ct,int,...)
			if s&LOCATION_HAND==LOCATION_HAND then
				Genex_discard_effect_location_check=true
			end
			return disexitingmatchingcard(filter,player,s,o,ct,int,...)
		end
		Effect.SetRange=function(effect,range)
			Genex_effect_range[effect]=range
			return esetrange(effect,range)
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				if eff:GetCost() then
					local cost=eff:GetCost()
					Genex_discard_effect_check=false
					Genex_discard_effect_location_check=false
					Genex_discard_effect_location_check2=false
					Genex_discard_effect_c=nil

					local r=cost(e,tp,eg,ep,ev,re,r,rp,0)
					if Genex_discard_effect_check and (Genex_discard_effect_location_check or (Genex_effect_range[effect] and Genex_effect_range[effect]&LOCATION_HAND==LOCATION_HAND and Genex_discard_effect_c and Genex_discard_effect_c==e:GetHandler())) then
						eff:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
							if chk==0 then
								if Duel.GetFlagEffect(tp,id)~=0 then
									Genex_cost_check=true
									local Genex_boolean=cost(e,tp,eg,ep,ev,re,r,rp,0)
									Genex_cost_check=false
									return Genex_boolean and e:GetHandler():GetFlagEffect(id)==0
								end
								return cost(e,tp,eg,ep,ev,re,r,rp,0)
							end
							if Duel.GetFlagEffect(tp,id)~=0 then
								--Genex_cost_check=true
								--cost(e,tp,eg,ep,ev,re,r,rp,chk)
								--Genex_cost_check=false
								Duel.Hint(HINT_CARD,0,id)
								e:GetHandler():RegisterFlagEffect(e:GetHandler(),id,RESET_CHAIN,0,1)
								return 
							end
							cost(e,tp,eg,ep,ev,re,r,rp,chk)
						end)
						Genex_discard_effect_check2=true
					end
				end
				table.insert(table_effect,eff)
			end
			return 
		end

		for tc in aux.Next(g) do
			table_effect={}
			Genex_discard_effect_check2=false
			Duel.CreateToken(0,tc:GetOriginalCode())
			if Genex_discard_effect_check2 then
				tc:ReplaceEffect(id,0)
				for key,eff in ipairs(table_effect) do
					Genex_cregister(tc,eff)
				end
			end
		end

		--reset
		Card.RegisterEffect=Genex_cregister
		Duel.IsExistingMatchingCard=disexitingmatchingcard
		Effect.SetRange=esetrange

		Card.IsDiscardable=function(card,reason)
			if Genex_cost_check and Duel.GetFlagEffect(tp,id)~=0 then
				return true
			end
			return cisdiscardable(card,reason)
		end
		Card.IsAbleToGraveAsCost=function(card)
			if Genex_cost_check and Duel.GetFlagEffect(tp,id)~=0 then
				return true
			end
			return cisabletograveascost(card)
		end
		Card.RegisterEffect=function(card,effect,flag)
			if card:IsSetCard(0x2) and card:IsType(TYPE_MONSTER) and effect:GetCost() then
				local cregister=Card.RegisterEffect
				local cisdiscardable=Card.IsDiscardable
				local cisabletograveascost=Card.IsAbleToGraveAsCost
				local disexitingmatchingcard=Duel.IsExistingMatchingCard
				Card.IsDiscardable=function(card2,reason)
					Genex_discard_effect_c=card2
					Genex_discard_effect_check=true
					return true
				end
				Card.IsAbleToGraveAsCost=function(card2)
					Genex_discard_effect_c=card2
					Genex_discard_effect_check=true
					return true
				end
				Duel.IsExistingMatchingCard=function(filter,player,s,o,ct,int,...)
					if s&LOCATION_HAND==LOCATION_HAND then
						Genex_discard_effect_location_check=true
					end
					return disexitingmatchingcard(filter,player,s,o,ct,int,...)
				end
				Genex_discard_effect_check=false
				Genex_discard_effect_location_check=false
				Genex_discard_effect_c=nil
				local cost=effect:GetCost()
				local r=cost(e,tp,eg,ep,ev,re,r,rp,0)
				if Genex_discard_effect_check and (Genex_discard_effect_location_check or (effect:GetRange()&LOCATION_HAND==LOCATION_HAND and Genex_discard_effect_c and Genex_discard_effect_c==e:GetHandler())) then
					effect:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
						if chk==0 then
							if Duel.GetFlagEffect(tp,id)~=0 then
								Genex_cost_check=true
								local Genex_boolean=cost(e,tp,eg,ep,ev,re,r,rp,0)
								Genex_cost_check=false
								return Genex_boolean and e:GetHandler():GetFlagEffect(id)==0
							end
							return cost(e,tp,eg,ep,ev,re,r,rp,0)
						end
						if Duel.GetFlagEffect(tp,id)~=0 then
							--Genex_cost_check=true
							--cost(e,tp,eg,ep,ev,re,r,rp,chk)
							--Genex_cost_check=false
							Duel.Hint(HINT_CARD,0,id)
							e:GetHandler():RegisterFlagEffect(e:GetHandler(),id,RESET_CHAIN,0,1)
							return 
						end
						cost(e,tp,eg,ep,ev,re,r,rp,chk)
					end)
				end
				--reset
				Card.IsDiscardable=cisdiscardable
				Card.IsAbleToGraveAsCost=cisabletograveascost
				Duel.IsExistingMatchingCard=disexitingmatchingcard
			end
			return Genex_cregister(card,effect,flag)
		end
	end
	e:Reset()
end
