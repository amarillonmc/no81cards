--虫融姬战国大国主·轰征神蜂
function c10105907.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,10105906,aux.FilterBoolFunction(Card.IsFusionSetCard,0x8cdd),5,5,true,true)
	--spsummon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(c10105907.xspcost)
	e0:SetOperation(c10105907.xspop)
	c:RegisterEffect(e0)
	--atk 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x8cdd))
	e1:SetValue(function(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsRace(RACE_INSECT) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*200 end)
	c:RegisterEffect(e1)
	--disable 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,10105907)
	e2:SetCondition(c10105907.discon)
	e2:SetTarget(c10105907.distg)
	e2:SetOperation(c10105907.disop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,20105907) 
	e3:SetTarget(c10105907.sptg)
	e3:SetOperation(c10105907.spop)
	c:RegisterEffect(e3) 
	--to grave 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c10105907.tgcon)
	e4:SetTarget(c10105907.tgtg)
	e4:SetOperation(c10105907.tgop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(10105907,ACTIVITY_SPSUMMON,c10105907.counterfilter)
end
function c10105907.counterfilter(c)
	return c:IsSetCard(0x8cdd)
end 
function c10105907.xspcost(e,c,tp)
	return Duel.GetCustomActivityCount(10105907,tp,ACTIVITY_SPSUMMON)==0
end
function c10105907.xspop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10105907.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10105907.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x8cdd) 
end
function c10105907.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c10105907.disfilter(c)
	return c:IsSetCard(0x8cdd) and c:IsAbleToHand()
end
function c10105907.distg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c10105907.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
		 local tc=g:GetFirst() 
		 while tc do 
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(RACE_INSECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		tc=g:GetNext()
		end
	end 
end
function c10105907.spfilter(c,e,tp)
	return c:IsSetCard(0x8cdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c10105907.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and Duel.IsExistingMatchingCard(c10105907.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10105907.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and Duel.IsExistingMatchingCard(c10105907.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then 
		local sg=Duel.SelectMatchingCard(tp,c10105907.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil,e,tp)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then   
			local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsRace(RACE_INSECT) end,tp,LOCATION_MZONE,0,nil) 
			if x>0 then  
				Duel.BreakEffect() 
				Duel.Damage(1-tp,x*500,REASON_EFFECT) 
			end 
		end 
	end
end
function c10105907.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ((rp==1-tp and c:IsReason(REASON_EFFECT)) or c:IsReason(REASON_BATTLE)) and c:IsPreviousLocation(LOCATION_ONFIELD)   
end 
function c10105907.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD,2,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,1-tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c10105907.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD,2,nil) then 
		local sg=Duel.SelectMatchingCard(1-tp,nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD,2,2,nil) 
		if sg:GetCount()>0 then 
			Duel.SendtoGrave(sg,REASON_RULE) 
		end 
	end 
end 






