--奥树
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)

	--handtrap check
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)

end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev)
		and bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function s.costfilter(c)
	return s.IsHandTrap(c) and c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,0,LOCATION_GRAVE,1,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tc=Duel.GetOperatedGroup()
	e:SetLabel(#tc)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(re,rp,tp)
	return not s.IsHandTrap(re:GetHandler())
end
function s.thfilter2(c)
	return s.IsHandTrap(c)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		if Duel.GetMatchingGroupCount(Card.IsOnField,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>0
			and e:GetLabel()==2
			and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,Card.IsOnField,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end

---------------------------Hand_Trap_Check----------------------------

function s.IsHandTrap(c)
	local code=c:GetOriginalCode()
	return Blacklotus_Handtrap_codetable[code]
end
function s.filter(c)
	return not c:IsCode(id)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not Blacklotus_Handtrap_globle_check then
		Blacklotus_Handtrap_globle_check=true
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		local cregister=Card.RegisterEffect
		local esetrange=Effect.SetRange
		local eclone=Effect.Clone
		local cisdiscardable=Card.IsDiscardable
		local cisabletograveascost=Card.IsAbleToGraveAsCost
		Blacklotus_Handtrap_codetable={}
		table_effect={}
		table_range={}
		local handtrap_check_card=nil
		local handtrap_boolean=false
		local handtrap_copy_check=false
		local handtrap_count=0
		Effect.SetRange=function(effect,range)
			table_range[effect]=range
			return esetrange(effect,range)
			end
		s.GetRange=function(effect)
			if table_range[effect] then 
				return table_range[effect]
			end
			return nil
		end
		Card.IsDiscardable=function(card,reason)
			if card==handtrap_check_card then 
				handtrap_boolean=true
			end
			return cisdiscardable(card,reason)
		end
		Card.IsAbleToGraveAsCost=function(card)
			if card==handtrap_check_card then 
				handtrap_boolean=true
			end
			return cisabletograveascost(card)
		end
		Effect.Clone=function(effect)
			handtrap_copy_check=true
			return eclone(effect)
		end
		BlackLotus_ElementSaber_Effect={}
		Card.RegisterEffect=function(card,effect,flag)
			local res=cregister(card,effect,flag)
			if effect and (effect:GetCost() and card:IsType(TYPE_MONSTER) and s.GetRange(effect) and s.GetRange(effect)==LOCATION_HAND and bit.band(effect:GetType(),EFFECT_TYPE_IGNITION+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)~=0 and bit.band(effect:GetType(),EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_GRANT+EFFECT_TYPE_EQUIP)==0) then
				--Duel.Hint(HINT_CARD,0,card:GetOriginalCode())
				handtrap_check_card=card
				local cost=effect:GetCost()
				cost(effect,tp,eg,ep,ev,re,r,rp,0)
			end
			if effect and (not effect:IsHasProperty(EFFECT_FLAG_UNCOPYABLE)) and not handtrap_copy_check then
				handtrap_count=handtrap_count+1
			end
			if effect and (effect:IsHasType(EFFECT_TYPE_SINGLE) and card:IsType(TYPE_TRAP) and bit.band(effect:GetCode(),EFFECT_TRAP_ACT_IN_HAND)==EFFECT_TRAP_ACT_IN_HAND) then
				handtrap_boolean=true
				Blacklotus_Handtrap_codetable[card:GetOriginalCode()]=true 
				--Duel.Hint(HINT_CARD,0,card:GetOriginalCode())
			end
			handtrap_copy_check=false
			return res
		end
		for tc in aux.Next(g) do
			handtrap_boolean=false
			handtrap_count=0
			Duel.CreateToken(0,tc:GetOriginalCode())
			if handtrap_boolean and handtrap_count==1 then 
				Blacklotus_Handtrap_codetable[tc:GetOriginalCode()]=true 
				--Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			end
		end
		Card.RegisterEffect=cregister
		Effect.SetRange=esetrange
		Effect.Clone=eclone
		Card.IsDiscardable=cisdiscardable
		Card.IsAbleToGraveAsCost=cisabletograveascost
	end
	e:Reset()
end
