--古战士最终战士
function c91000338.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c91000338.filter,nil,nil,c91000338.matfilter,true) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,91000338)
	c:RegisterEffect(e1)  
	--xx
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,91000338*2)
	e2:SetCondition(function(e) 
	return  e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)end)
	e2:SetTarget(c91000338.ritg)
	e2:SetOperation(c91000338.riops) 
	c:RegisterEffect(e2)  
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c91000338.aclimit)
	c:RegisterEffect(e1)
	--ri 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_RELEASE) 
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e4:SetCountLimit(1,19100338) 
	e4:SetOperation(c91000338.riop) 
	c:RegisterEffect(e4)
	--special summon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c91000338.spccost)
	e0:SetOperation(c91000338.spcop)
	c:RegisterEffect(e0)   
	if not c91000338.global_check then
		c91000338.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c91000338.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
c91000338.SetCard_Dr_AcWarrior=true 
function c91000338.checkop(e,tp,eg,ep,ev,re,r,rp) 
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.RegisterFlagEffect(rp,91000338,RESET_PHASE+PHASE_END,0,0)  
	end  
end
function c91000338.spccost(e,c,tp)
	return Duel.GetFlagEffect(tp,91000338)==0 
end
function c91000338.spcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)  
	e2:SetValue(c91000338.actlimit)
	Duel.RegisterEffect(e2,tp) 
end
function c91000338.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c91000338.filter(c,e,tp,chk)
	return c:IsLevel(10) and c:IsType(TYPE_RITUAL) 
end
function c91000338.matfilter(c,e,tp,chk)
	return not chk or true 
end 
function c91000338.xxop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0) 
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c91000338.riop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_END) 
	e1:SetCountLimit(1) 
	e1:SetCondition(c91000338.riscon)  
	e1:SetOperation(c91000338.risop) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c91000338.rrlfil(c,e,tp) 
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0  
end 
function c91000338.riscon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c91000338.rrlfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)  
end 
function c91000338.risop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(c91000338.rrlfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then 
		Duel.Hint(HINT_CARD,0,91000338) 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c91000338.rrlfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
		Duel.Release(g,REASON_EFFECT)
		Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) 
	end 
end  
function c91000338.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER)
end
function c91000338.ritg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)  end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c91000338.fitd(c)
	return c:IsLevel(10) and c:IsReleasableByEffect()
end
function c91000338.riops(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c91000338.fitd,tp,LOCATION_MZONE,0,1,nil) then
	local g=Duel.SelectMatchingCard(tp,c91000338.fitd,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_EFFECT)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	end
end







