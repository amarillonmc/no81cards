--全解放封灵师 虎生
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--place and special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)   
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.cost)
	c:RegisterEffect(e2)  
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)  
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.val)
	c:RegisterEffect(e4)
	--Banish cards from the opponent's deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,id+1)
	e5:SetCondition(aux.NOT(s.effcon))
	e5:SetTarget(s.dktg)
	e5:SetOperation(s.dkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(s.effcon)
	c:RegisterEffect(e6)
end
function s.plfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x6224) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.spselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.plfilter,tp,0x16,0,c)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and g:CheckSubGroup(s.spselect,2,2,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.plfilter,tp,0x16,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=g:SelectSubGroup(tp,s.spselect,false,2,2,tp)
	if not tg or #tg~=2 then return end
	local sp=false
	for tc in aux.Next(tg) do
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			--Treated as a Continuous Spell
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
			tc:RegisterEffect(e1)
			sp=true
		end
	end
	if c:IsRelateToEffect(e) and sp then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,11603038)}) do
		fg:AddCard(pe:GetHandler())
	end
	if chk==0 then return #fg>=1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11603037,0))
	local fc=nil
	if #fg==1 then
		fc=fg:GetFirst()
	else
		fc=fg:Select(tp,1,1,nil)
	end
	Duel.Hint(HINT_CARD,0,fc:GetCode())
	fc:RegisterFlagEffect(11603038,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAllTypes(TYPE_CONTINUOUS+TYPE_TRAP) and Duel.IsPlayerAffectedByEffect(tp,11603037)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER 
end
function s.val(e,c)
	local g=Duel.GetMatchingGroup(s.atkfilter,0,LOCATION_SZONE,LOCATION_SZONE,nil)
	return g:GetSum(Card.GetAttack)/2
end
function s.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,2,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,1-tp,LOCATION_DECK)
end
function s.dkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,1-tp,LOCATION_DECK,0,2,2,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end