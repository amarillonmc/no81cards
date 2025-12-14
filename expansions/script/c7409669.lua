--不可见之天国
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)
end
function s.thfilter(c)
	return not c:IsCode(id) and c:IsSetCard(0x1d3) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.filter(c)
	return c:IsOriginalSetCard(0x1d3) and c:IsType(TYPE_MONSTER)
end
function s.quick_filter(e)
	if e:IsHasType(EFFECT_TYPE_IGNITION) and 
	   e:IsHasRange(LOCATION_HAND+LOCATION_MZONE) and not s.in_array(e,Blacklotus_Hecatoncheires_Effect) then
		Blacklotus_Hecatoncheires_Effect[#Blacklotus_Hecatoncheires_Effect+1]=e
		return true
	end
	return false
end
function s.in_array(b,list)
  if not list then
	return false 
  end 
  if list then
	for _,ct in pairs(list) do
	  if ct==b then return true end
	end
  end
  return false
end 
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local c=e:GetHandler()
		--
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			Blacklotus_Hecatoncheires_Effect={}
			local boolean=true
			while boolean do
				boolean=tc:IsOriginalEffectProperty(s.quick_filter)
			end
			if #Blacklotus_Hecatoncheires_Effect>0 then
				for _,effect in pairs(Blacklotus_Hecatoncheires_Effect) do
					local c_effect=effect:Clone()
					local condition=effect:GetCondition()
					c_effect:SetDescription(aux.Stringid(id,4))
					c_effect:SetType(EFFECT_TYPE_QUICK_O)
					c_effect:SetCode(EVENT_FREE_CHAIN)
					c_effect:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE+TIMING_MAIN_END)
					c_effect:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
						if condition then 
							return condition and Duel.IsPlayerAffectedByEffect(tp,id)~=nil and (Duel.GetCurrentChain()~=0 or not((Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp))
						else
							return Duel.IsPlayerAffectedByEffect(tp,id)~=nil and (Duel.GetCurrentChain()~=0 or not((Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp))
						end
					end)
					tc:RegisterEffect(c_effect)
				end
			end
		end
	end
	e:Reset()
end
