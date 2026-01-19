--原石龙 变种蓝宝石龙
local s,id,o=GetID()
function s.initial_effect(c)
	--change name
	aux.AddCodeList(c,11091375)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE)
	--e0:SetCondition(s.condition)
	e0:SetValue(11091375)
	c:RegisterEffect(e0)
	--normal monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(TYPE_NORMAL)
	--e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	--summon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCost(s.costchk)
	e3:SetOperation(s.costop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	--special summon
	--[[local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e5:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e5:SetCountLimit(1,id)
	e5:SetCondition(s.spcon)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)]]
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local CGetType=Card.GetType
		Card.GetType=(function(card)
			if --s.condition() and 
			card:GetOriginalCode()==7498739 and card:IsLocation(LOCATION_DECK) then
				return TYPE_MONSTER+TYPE_NORMAL 
			end
			return CGetType(card)
		end)
		local CGetOriginalType=Card.GetOriginalType
		Card.GetOriginalType=(function(card)
			if --s.condition() and 
			card:GetOriginalCode()==7498739 and card:IsHasEffect(EFFECT_CHANGE_CODE) then
				return TYPE_MONSTER+TYPE_NORMAL 
			end
			return CGetOriginalType(card)
		end)
		local CIsType=Card.IsType
		Card.IsType=(function(card,type)
			if --s.condition() and 
			card:GetOriginalCode()==7498739 and card:IsLocation(LOCATION_DECK) then
				return bit.band(TYPE_MONSTER+TYPE_NORMAL,type)~=0
			end
			return CIsType(card,type)
		end)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain()
	if ch<=0 then return false end
	local p,code,te=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_EFFECT)
	return te and te:GetHandler() and te:GetHandler():IsSetCard(0x1b9)
end
function s.efilter(e)
	local c=e:GetHandler()
	local cost=e:GetCost()
	if not cost or not e:IsHasRange(LOCATION_GRAVE) then return false end
	local remove_boolean=false
	local cIsAbleToRemoveAsCost=Card.IsAbleToRemoveAsCost
	Card.IsAbleToRemoveAsCost=function(card)
		if card==c then 
		   remove_boolean=true
		end
		return cIsAbleToRemoveAsCost(card)
	end
	pcall(cost(e,0,nil,0,0,nil,0,0,0))
	Card.IsAbleToRemoveAsCost=cIsAbleToRemoveAsCost
	return remove_boolean
end
function s.tgfilter(c)
	return c:IsSetCard(0x1b9) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsOriginalEffectProperty(s.efilter)
end
function s.costchk(e,te_or_c,tp)
	return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if #tg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=tg:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_COST)
	end
end
function s.cfilter(c,tp)
	return (c:GetPreviousTypeOnField()&TYPE_NORMAL)>0
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(s.cfilter,1,nil,p) then
			Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
