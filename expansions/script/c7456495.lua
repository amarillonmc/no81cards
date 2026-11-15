--永火欺诈师
local s,id,o=GetID()
local Blacklotus_Neet_Infernity_Effect={}
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),2,2)
	c:EnableReviveLimit()
	--add con
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.setcon)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
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
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function s.setcfilter(c)
	return c:IsSetCard(0xb) and c:IsAbleToGraveAsCost()
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setcfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.setcfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.setfilter(c)
	return c:IsSetCard(0xb) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end

--------------------------------add con----------------------------------------
function s.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.quick_filter(e)
	if (e:IsHasType(EFFECT_TYPE_QUICK_O) or e:IsHasType(EFFECT_TYPE_TRIGGER_O) or e:IsHasType(EFFECT_TYPE_TRIGGER_F) or e:IsHasType(EFFECT_TYPE_IGNITION)) and 
	   e:GetCondition() and not s.in_array(e,Blacklotus_Neet_Infernity_Effect) then
		local boolean=0
		local condition=e:GetCondition()
		local _GetFieldGroupCount=Duel.GetFieldGroupCount
		Duel.GetFieldGroupCount=function(pl,s,o)
			if s==LOCATION_HAND and boolean==0 then
				boolean=1
			end
			if o~=0 then
				boolean=2
			end
			return _GetFieldGroupCount(pl,s,o)
		end
		local _GetAttacker=Duel.GetAttacker
		Duel.GetAttacker=function()
			return e:GetHandler()
		end
		pcall(condition(e,0,Group.CreateGroup(),0,0,e,0,0))
		Duel.GetFieldGroupCount=_GetFieldGroupCount
		Duel.GetAttacker=_GetAttacker
		if boolean==1 then
			Blacklotus_Neet_Infernity_Effect[#Blacklotus_Neet_Infernity_Effect+1]=e
		end
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
			Blacklotus_Neet_Infernity_Effect={}
			local boolean=tc:IsOriginalEffectProperty(s.quick_filter)
			if #Blacklotus_Neet_Infernity_Effect>0 then
				for _,effect in pairs(Blacklotus_Neet_Infernity_Effect) do
					local c_effect=effect:Clone()
					local condition=effect:GetCondition()
					local cost=effect:GetCost()
					c_effect:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
						local te=Duel.IsPlayerAffectedByEffect(tp,id)
						if not te or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return false end
						local _GetFieldGroupCount=Duel.GetFieldGroupCount
						Duel.GetFieldGroupCount=function(pl,s,o)
							if pl==tp and s==LOCATION_HAND and o==0 then
								return 0
							end
							return _GetFieldGroupCount(pl,s,o)
						end
						local boolean=not condition or condition(e,tp,eg,ep,ev,re,r,rp)
						Duel.GetFieldGroupCount=_GetFieldGroupCount
						return boolean
					end)
					c_effect:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
						local te=Duel.IsPlayerAffectedByEffect(tp,id)
						if not te or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return false end
						if chk==0 then return (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) end
						Duel.Hint(HINT_CARD,0,id)
						te:UseCountLimit(tp)
						if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
					end)
					tc:RegisterEffect(c_effect)
				end
			end
		end
	end
	e:Reset()
end

