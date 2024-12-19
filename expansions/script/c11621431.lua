--桃渊明
function c11621431.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,11621403)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c11621431.splimit)
	c:RegisterEffect(e0)
	--special summon (hand/grave)
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11621431,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE) 
	e1:SetCost(c11621431.spcost)
	e1:SetTarget(c11621431.sptg)
	e1:SetOperation(c11621431.spop)
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11621431,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c11621431.discon) 
	e2:SetTarget(c11621431.distg)
	e2:SetOperation(c11621431.disop)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c11621431.atkval)
	c:RegisterEffect(e3)  
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4) 
	--xx 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_CODE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,0x7f)
	e5:SetTarget(c11621431.crtg) 
	e5:SetValue(11621403)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CHANGE_RACE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,0x7f)
	e6:SetTarget(c11621431.crtg) 
	e6:SetValue(RACE_ZOMBIE) 
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,0x7f)
	e7:SetTarget(c11621431.crtg) 
	e7:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e7)
	--
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD) 
	e8:SetCode(EFFECT_CHANGE_LEVEL)  
	e8:SetRange(LOCATION_MZONE) 
	e8:SetTargetRange(0,0x7f)
	e8:SetTarget(c11621431.crtg1) 
	e8:SetValue(3)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)  
	e9:SetCode(EFFECT_CHANGE_RANK)   
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,0x7f)
	e9:SetTarget(c11621431.crtg2) 
	e9:SetValue(3)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD) 
	e10:SetCode(EFFECT_UPDATE_LINK)  
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(0,0x7f)
	e10:SetTarget(c11621431.crtg3) 
	e10:SetValue(3)
	c:RegisterEffect(e10)
	if not c11621431.global_check then
		c11621431.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c11621431.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c11621431.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard(0x5220) and re:IsActiveType(TYPE_TRAP) then  
		local flag=Duel.GetFlagEffectLabel(rp,11621431)
		if flag==nil then 
			Duel.RegisterFlagEffect(rp,11621431,0,0,1,1) 
		else 
			Duel.SetFlagEffectLabel(rp,11621431,flag+1) 
		end 
	end
end
function c11621431.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x5220) 
end
function c11621431.rfilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue()
	end
	return c:IsSetCard(0x5220) and (val==nil or val(re,c)~=true) 
end
function c11621431.rlgck(g,tp)
	return aux.dncheck(g) 
	   and Duel.GetMZoneCount(tp,g)>0 
end
function c11621431.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11621431.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler(),tp)
	if chk==0 then return g:CheckSubGroup(c11621431.rlgck,3,3,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,c11621431.rlgck,false,3,3,tp)
	Duel.Release(rg,REASON_COST) 
end
function c11621431.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11621431.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	end
end
function c11621431.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end 
function c11621431.dthfil(c) 
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue()
	end
	return c:IsSetCard(0x5220) and c:IsAbleToHand() and (val==nil or val(re,c)~=true)  
end 
function c11621431.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11621431.dthfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c11621431.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,c11621431.dthfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	if tc and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then 
		Duel.ConfirmCards(1-tp,tc)
		if Duel.Release(tc,REASON_RULE)~=0 and Duel.NegateActivation(ev) and c:IsRelateToEffect(e) then 
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11621431,2))
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
			e1:SetCode(EVENT_CHAINING)
			e1:SetRange(LOCATION_MZONE) 
			e1:SetCondition(c11621431.datkcon) 
			e1:SetOperation(c11621431.datkop) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e1)   
		end 
	end 
end
function c11621431.datkcon(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)  
	return rp==tp and re:GetHandler():IsSetCard(0x5220) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and g:GetCount()>0 
end 
function c11621431.datkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)   
	if rp==tp and re:GetHandler():IsSetCard(0x5220) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and g:GetCount()>0 then  
		local tc=g:GetFirst() 
		while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(-300) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)   
			tc=g:GetNext() 
		end 
	end 
end 
function c11621431.atkval(e) 
	local tp=e:GetHandlerPlayer() 
	local flag=Duel.GetFlagEffectLabel(tp,11621431)
	if flag==nil then 
		return 0 
	else 
		return flag*200 
	end 
end 
function c11621431.crckfil(c) 
	return c:IsFaceup() and (c:IsAttack(0) or c:IsDefense(0))
end 
function c11621431.crtg(e,c)
	local tp=e:GetHandlerPlayer() 
	local g=Duel.GetMatchingGroup(c11621431.crckfil,tp,0,LOCATION_MZONE,nil)
	return g:IsExists(Card.IsOriginalCodeRule,1,nil,c:GetOriginalCodeRule()) 
end
function c11621431.crtg1(e,c)
	local tp=e:GetHandlerPlayer() 
	local g=Duel.GetMatchingGroup(c11621431.crckfil,tp,0,LOCATION_MZONE,nil)
	return g:IsExists(Card.IsOriginalCodeRule,1,nil,c:GetOriginalCodeRule()) and c:IsLevelAbove(1)
end
function c11621431.crtg2(e,c)
	local tp=e:GetHandlerPlayer() 
	local g=Duel.GetMatchingGroup(c11621431.crckfil,tp,0,LOCATION_MZONE,nil)
	return g:IsExists(Card.IsOriginalCodeRule,1,nil,c:GetOriginalCodeRule()) and c:IsRankAbove(1)
end
function c11621431.crtg3(e,c)
	local tp=e:GetHandlerPlayer() 
	local g=Duel.GetMatchingGroup(c11621431.crckfil,tp,0,LOCATION_MZONE,nil)
	return g:IsExists(Card.IsOriginalCodeRule,1,nil,c:GetOriginalCodeRule()) and c:IsLinkAbove(1)
end



