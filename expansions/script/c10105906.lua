--虫融姬战国主公·轰征王蜂
function c10105906.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c) return c:IsSetCard(0x8cdd) end,3,true)
	--spsummon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(c10105906.xspcost)
	e0:SetOperation(c10105906.xspop)
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
	return Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsRace(RACE_INSECT) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*100 end)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,10105906)
	e2:SetCondition(c10105906.thcon)
	e2:SetTarget(c10105906.thtg)
	e2:SetOperation(c10105906.thop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,20105906) 
	e3:SetTarget(c10105906.sptg)
	e3:SetOperation(c10105906.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(10105906,ACTIVITY_SPSUMMON,c10105906.counterfilter)
end
function c10105906.counterfilter(c)
	return c:IsSetCard(0x8cdd)
end 
function c10105906.xspcost(e,c,tp)
	return Duel.GetCustomActivityCount(10105906,tp,ACTIVITY_SPSUMMON)==0
end
function c10105906.xspop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10105906.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10105906.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x8cdd) 
end
function c10105906.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c10105906.thfilter(c)
	return c:IsSetCard(0x8cdd) and c:IsAbleToHand()
end
function c10105906.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105906.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10105906.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105906.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10105906.spfilter(c,e,tp)
	return c:IsSetCard(0x8cdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c10105906.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10105906.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10105906.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10105906.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then 
		local sg=Duel.SelectMatchingCard(tp,c10105906.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then   
			local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsRace(RACE_INSECT) end,tp,LOCATION_MZONE,0,nil)
			if x>0 then  
				Duel.BreakEffect() 
				Duel.Damage(1-tp,x*300,REASON_EFFECT) 
			end 
		end 
	end
end


