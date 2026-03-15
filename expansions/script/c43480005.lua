--被遗忘的研究 收容物无尽繁衍之兔
function c43480005.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,43480005)
	e1:SetCondition(c43480005.pspcon)
	e1:SetTarget(c43480005.psptg)
	e1:SetOperation(c43480005.pspop)
	c:RegisterEffect(e1)
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetTarget(c43480005.destg) 
	e1:SetOperation(c43480005.desop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA) 
	e2:SetCountLimit(1,43480006) 
	e2:SetCondition(c43480005.spcon)
	e2:SetTarget(c43480005.sptg)
	e2:SetOperation(c43480005.spop)
	c:RegisterEffect(e2) 
	--token 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE) 
	e3:SetCountLimit(1,43480007) 
	e3:SetCondition(function(e) 
	return e:GetHandler():GetEquipTarget()~=nil end) 
	e3:SetTarget(c43480005.tktg)
	e3:SetOperation(c43480005.tkop)
	c:RegisterEffect(e3)
end
function c43480005.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f13)
end
function c43480005.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43480005.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.IsEnvironment(4348070,tp) 
end
function c43480005.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43480005.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) 
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		e1:SetTarget(function(e,c) 
		return not c:IsSetCard(0x3f13) end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true) 
		Duel.SpecialSummonComplete()
	end
end
function c43480005.desfil(c) 
	return not (c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM))  
end 
function c43480005.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local dg=Duel.GetMatchingGroup(c43480005.desfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c43480005.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local p=tp 
	if Duel.IsPlayerAffectedByEffect(tp,4348050) then p=1-tp end 
	local dg=Duel.GetMatchingGroup(c43480005.desfil,p,LOCATION_MZONE,0,nil)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end 

function c43480005.spckfil(c,tp) 
	return c:IsSummonPlayer(tp) and c:IsFaceup() and c:IsSetCard(0x3f13)  
end
 
function c43480005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43480005.spckfil,1,nil,tp) 
end 

function c43480005.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
	local b2=e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())+Duel.GetMZoneCount(tp)>=2 
	if chk==0 then return (b1 or b2) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanSpecialSummonMonster(tp,43480006,0x3f13,TYPES_TOKEN_MONSTER,0,0,1,RACE_BEAST,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),2,0,0)
end

function c43480005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,43480006,0x3f13,TYPES_TOKEN_MONSTER,0,0,1,RACE_BEAST,ATTRIBUTE_LIGHT) then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,43480006)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetAbsoluteRange(tp,1,0)
			e1:SetTarget(function(e,c) 
			return not c:IsSetCard(0x3f13) end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(function(e,re,rp) 
			return re:GetHandler()==e:GetOwner() end)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end

function c43480005.tktg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,43480006,0x3f13,TYPES_TOKEN_MONSTER,0,0,1,RACE_ROCK,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c43480005.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,43480006,0x3f13,TYPES_TOKEN_MONSTER,0,0,1,RACE_BEAST,ATTRIBUTE_LIGHT) then 
		local token=Duel.CreateToken(tp,43480006)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(function(e,c) 
		return not c:IsSetCard(0x3f13) end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end 
end 


