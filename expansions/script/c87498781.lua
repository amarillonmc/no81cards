--黄金卿 黄金国巫妖 逆 
if not aux.pset_qechk then
	aux.pset_qechk=true
	_rge=Card.RegisterEffect 
	function Card.RegisterEffect(c,ie,ob)  
		local b=ob or false
		if not (c:IsOriginalCodeRule(95440946))
			or not (ie:IsHasType(EFFECT_TYPE_IGNITION)) 
			or (ie:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then
			return _rge(c,ie,b)
		end  
		local n1=_rge(c,ie,b)  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_PENDULUM) 
		e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_PZONE)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
		return Duel.IsPlayerAffectedByEffect(tp,87498781) end) 
		local qe=Effect.CreateEffect(c) 
		qe:SetDescription(aux.Stringid(87498781,3)) 
		qe:SetType(EFFECT_TYPE_IGNITION) 
		qe:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
		qe:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) 
		if chk==0 then return Duel.IsPlayerAffectedByEffect(tp,87498781) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end   
		local flag=0 
		flag=bit.bor(flag,1) 
		flag=bit.bor(flag,16) 
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true,flag) end)
		qe:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()   
		--scale
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_PZONE) 
		e1:SetValue(c:GetLevel())  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		c:RegisterEffect(e2)  
		end) 
		--
		local n2=_rge(c,qe,b)
		return n1,n2
	end
end
function c87498781.initial_effect(c) 
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87498781,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,87498781)
	e1:SetCost(c87498781.tgcost)
	e1:SetTarget(c87498781.tgtg)
	e1:SetOperation(c87498781.tgop)
	c:RegisterEffect(e1)	
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87498781,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,17498781)
	e2:SetCost(c87498781.thcost)
	e2:SetTarget(c87498781.thtg)
	e2:SetOperation(c87498781.thop)
	c:RegisterEffect(e2) 
	--P set 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(0xff)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c87498781.adop)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(87498781)
	e4:SetRange(LOCATION_PZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--PSUM 
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION) 
	e5:SetRange(LOCATION_PZONE) 
	e5:SetCost(c87498781.pspcost) 
	e5:SetTarget(c87498781.psptg) 
	e5:SetOperation(c87498781.pspop)
	c:RegisterEffect(e5)
end
function c87498781.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c87498781.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c87498781.costfilter,tp,LOCATION_HAND,0,1,c) and c:IsAbleToGraveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c87498781.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c87498781.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c87498781.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end 
function c87498781.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87498781.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c87498781.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end 
function c87498781.thfil(c) 
	return c:IsAbleToHand() and c:IsCode(95440946)   
end 
function c87498781.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c87498781.thfil,tp,LOCATION_DECK,0,nil)  
	if c:IsAbleToHand() then 
	g:AddCard(c)  
	end 
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c87498781.spfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c87498781.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c87498781.thfil,tp,LOCATION_DECK,0,nil)  
	if c:IsRelateToEffect(e) and c:IsAbleToHand() then 
	g:AddCard(c)  
	end 
	if g:GetCount()<=0 then return end 
	local sg=g:Select(tp,1,1,nil) 
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)==0 then return end 
	Duel.ConfirmCards(1-tp,sg) 
	if Duel.IsExistingMatchingCard(c87498781.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(87498781,2)) then 
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c87498781.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2) 
		end
		Duel.SpecialSummonComplete()
	end
end 
function c87498781.pspcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end  
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST) 
end 
function c87498781.pspfil(c,e,tp) 
	local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0) 
	local rc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)  
	if lc==nil then return false end 
	if rc==nil then return false end 
	local lsc=lc:GetLeftScale() 
	local rsc=rc:GetRightScale() 
	if lsc>rsc then lsc,rsc=rsc,lsc end
	local lv=c:GetOriginalLevel() 
	return c:IsSetCard(0x143) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x143,TYPES_NORMAL_TRAP_MONSTER,c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute(),POS_FACEUP,tp,SUMMON_TYPE_PENDULUM) and lv>0 and lv>lsc and lv<rsc   
end 
function c87498781.psptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c87498781.pspfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED) 
end 
function c87498781.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c87498781.pspfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp) 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()>0 and ft>0 then 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end  
	local sg=g:Select(tp,1,ft,nil)  
	local tc=sg:GetFirst() 
	while tc do 
	tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP) 
	Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,true,false,POS_FACEUP)  
	tc=sg:GetNext() 
	end 
	Duel.SpecialSummonComplete() 
	if sg:GetCount()>0 then 
	Duel.BreakEffect() 
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0) 
	Duel.Destroy(dg,REASON_EFFECT) 
	end 
	end 
end 
function c87498781.filsn(c)
	return c:IsOriginalCodeRule(95440946) and not c:GetFlagEffectLabel(87498781)
end
function c87498781.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(c87498781.filsn,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_HAND+LOCATION_GRAVE,c)
	local nc=ng:GetFirst()
	while nc do  
		nc:RegisterFlagEffect(87498781,RESETS_STANDARD,0,1)
		nc:ReplaceEffect(nc:GetCode(),0)
		nc=ng:GetNext()
	end
end








