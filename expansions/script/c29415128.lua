--隐匿之徒 布拉克侯
function c29415128.initial_effect(c)
	c:SetSPSummonOnce(29415128)
	c:SetUniqueOnField(1,0,29415128)
	--link summon
	aux.AddLinkProcedure(c,c29415128.mfilter,1,1)
	c:EnableReviveLimit()   
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29415128,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCondition(c29415128.hspcon)
	e1:SetTarget(c29415128.hsptg)
	e1:SetOperation(c29415128.hspop)
	c:RegisterEffect(e1)
	--spe
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c29415128.specon) 
	e2:SetTarget(c29415128.spetg)
	e2:SetOperation(c29415128.speop)
	c:RegisterEffect(e2) 
	-- 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c29415128.xxcon)
	e3:SetTarget(c29415128.xxtg)
	e3:SetOperation(c29415128.xxop)
	c:RegisterEffect(e3) 
	if not c29415128.global_check then
		c29415128.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c29415128.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
function c29415128.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if re and not re:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and re:GetHandler():IsSetCard(0x980) then 
			tc:RegisterFlagEffect(29415128,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_TEMP_REMOVE,0,1)
		end 
		tc=eg:GetNext()
	end
end
function c29415128.mfilter(c)
	return c:IsSetCard(0x980) or c:GetFlagEffect(29415128)~=0 
end
function c29415128.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c29415128.hspfilter(c,e,tp)
	return (c:IsSetCard(0x980) and c:IsSummonableCard()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29415128.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29415128.hspfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c29415128.hspop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c29415128.hspfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst() 
	if tc then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end 
end
function c29415128.specon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0x980) end,tp,LOCATION_MZONE,0,1,nil)   
end  
function c29415128.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x980) 
end
function c29415128.xyzfilter(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x980) 
end
function c29415128.spetg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(c29415128.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c29415128.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)
	if chk==0 then return b1 or b2 end 
end  
function c29415128.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local b1=Duel.IsExistingMatchingCard(c29415128.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c29415128.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)
	if b1 or b2 then 
		local xtable={} 
		if b1 then table.insert(xtable,aux.Stringid(29415128,1)) end 
		if b2 then table.insert(xtable,aux.Stringid(29415128,2)) end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
		if xtable[op]==aux.Stringid(29415128,1) then 
			local sc=Duel.SelectMatchingCard(tp,c29415128.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst() 
			Duel.Summon(tp,sc,true,nil)
		end 
		if xtable[op]==aux.Stringid(29415128,2) then 
			local sc=Duel.SelectMatchingCard(tp,c29415128.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst() 
			Duel.XyzSummon(tp,sc,nil) 
		end 
	end
end
function c29415128.xxckfil(c,e) 
	return e:GetHandler():GetLinkedGroup():IsContains(c)  
end 
function c29415128.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x980) and eg:IsExists(c29415128.xxckfil,1,nil,e)
end
function c29415128.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0)  
	if chk==0 then return tc and tc:IsAbleToHand() end   
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end 
function c29415128.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0)  
	if tc then 
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
	end   
end 



