--指引前路的苍蓝之星·太刀
function c11579808.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,3,nil,nil,99) 
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c11579808.lvtg)
	e1:SetValue(c11579808.lvval)
	c:RegisterEffect(e1) 
	--sb 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1)  
	e2:SetTarget(c11579808.sbtg) 
	e2:SetOperation(c11579808.sbop) 
	c:RegisterEffect(e2)
end
c11579808.SetCard_ZH_Bluestar=true  
function c11579808.lvtg(e,c)
	return c.SetCard_ZH_Bluestar 
end
function c11579808.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 4 
	else return lv end
end 
function c11579808.sbtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local x=c:RemoveOverlayCard(tp,1,4,REASON_COST)  
	e:SetLabel(x)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(11579808,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		local seq=math.log(fd,2)
		local pseq=c:GetSequence()
		Duel.MoveSequence(c,seq) 
	end  
end  
function c11579808.exgfil(c,seq) 
	if seq>4 then return false end 
	return c:GetSequence()<5 and math.abs(c:GetSequence()-seq)==1 
end 
function c11579808.sbop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	if c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(500*x) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
		if c:GetFlagEffect(11579808)~=0 and c:GetFlagEffect(21579808)~=0 and c:GetFlagEffect(31579808)~=0 and c:GetFlagEffect(41579808)~=0 then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(2000) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
	end  
	local b1=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):GetCount()>0 and c:GetFlagEffect(11579808)==0  
	local b2=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE):GetCount()>0 and c:GetFlagEffect(21579808)==0  
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil) and c:GetFlagEffect(31579808)==0  
	local b4=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) and c:GetFlagEffect(41579808)==0   
	local xchk=0 
	if b1 then xchk=xchk+1 end 
	if b2 then xchk=xchk+1 end 
	if b3 then xchk=xchk+1 end 
	if b4 then xchk=xchk+1 end 
	c11579808.xtable={} 
	c11579808.sltable={} 
	if b1 then table.insert(c11579808.xtable,aux.Stringid(11579808,1)) end   
	if b2 then table.insert(c11579808.xtable,aux.Stringid(11579808,2)) end   
	if b3 then table.insert(c11579808.xtable,aux.Stringid(11579808,3)) end   
	if b4 then table.insert(c11579808.xtable,aux.Stringid(11579808,4)) end  
	local b=0 
	while b<x do 
		local op=Duel.SelectOption(tp,table.unpack(c11579808.xtable))+1   
		local sbck=c11579808.xtable[op] 
		if sbck==aux.Stringid(11579808,1) then 
			c:RegisterFlagEffect(11579808,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11579808,5))
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
		end 
		if sbck==aux.Stringid(11579808,2) then 
			c:RegisterFlagEffect(21579808,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11579808,6))
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
		end 
		if sbck==aux.Stringid(11579808,3) then
			c:RegisterFlagEffect(31579808,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11579808,7)) 
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
		end 
		if sbck==aux.Stringid(11579808,4) then 
			c:RegisterFlagEffect(41579808,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11579808,8))
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
		end 
		table.insert(c11579808.sltable,sbck) 
		table.remove(c11579808.xtable,op) 
		b=b+1 
		if b<x and not Duel.SelectYesNo(tp,aux.Stringid(11579808,9)) then b=x end 
	end 
		local a=1
		while a<=x do 
		local sbck=c11579808.sltable[a] 
		if sbck==aux.Stringid(11579808,1) then 
			local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end 
		if sbck==aux.Stringid(11579808,2) then 
			local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE) 
			local tc=g:GetFirst() 
			while tc do 
			local exg=Duel.GetMatchingGroup(c11579808.exgfil,tp,0,LOCATION_MZONE,nil,tc:GetSequence()) 
			g:Merge(exg)
			tc=g:GetNext()
			end 
			Duel.SendtoGrave(g,REASON_EFFECT)
		end 
		if sbck==aux.Stringid(11579808,3) then 
			local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
			local dg=g:RandomSelect(tp,1) 
			Duel.SendtoGrave(dg,REASON_EFFECT)
		end 
		if sbck==aux.Stringid(11579808,4) then 
			local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil) 
			Duel.ConfirmCards(tp,g) 
			local dg=g:Select(tp,1,1,nil) 
			Duel.SendtoGrave(dg,REASON_EFFECT)
		end 
		a=a+1   
		end 
	end 
end 




function c11579808.sbtg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local b1=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):GetCount()>0 and c:GetFlagEffect(11579808)==0  
	local b2=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE):GetCount()>0 and c:GetFlagEffect(21579808)==0  
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil) and c:GetFlagEffect(31579808)==0  
	local b4=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) and c:GetFlagEffect(41579808)==0  
	local xchk=0 
	if b1 then xchk=xchk+1 end 
	if b2 then xchk=xchk+1 end 
	if b3 then xchk=xchk+1 end 
	if b4 then xchk=xchk+1 end 
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and xchk>0 end
	local x=c:RemoveOverlayCard(tp,1,xchk,REASON_COST)  
	e:SetLabel(x)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(11579808,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		local seq=math.log(fd,2)
		local pseq=c:GetSequence()
		Duel.MoveSequence(c,seq) 
	end 
	c11579808.xtable={} 
	c11579808.sltable={} 
	if b1 then table.insert(c11579808.xtable,aux.Stringid(11579808,1)) end   
	if b2 then table.insert(c11579808.xtable,aux.Stringid(11579808,2)) end   
	if b3 then table.insert(c11579808.xtable,aux.Stringid(11579808,3)) end   
	if b4 then table.insert(c11579808.xtable,aux.Stringid(11579808,4)) end   
	while x>0 do 
		local op=Duel.SelectOption(tp,table.unpack(c11579808.xtable))+1   
		local sbck=c11579808.xtable[op] 
		if sbck==aux.Stringid(11579808,1) then 
			c:RegisterFlagEffect(11579808,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11579808,5))
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
		end 
		if sbck==aux.Stringid(11579808,2) then 
			c:RegisterFlagEffect(21579808,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11579808,6))
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
		end 
		if sbck==aux.Stringid(11579808,3) then
			c:RegisterFlagEffect(31579808,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11579808,7)) 
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
		end 
		if sbck==aux.Stringid(11579808,4) then 
			c:RegisterFlagEffect(41579808,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11579808,8))
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
		end 
		table.insert(c11579808.sltable,sbck) 
		table.remove(c11579808.xtable,op)
		x=x-1
	end 
end   
function c11579808.sbop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	if c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(500*x) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
		if x==4 then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(2000) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
	end  
		local a=1
		while a<=x do 
		local sbck=c11579808.sltable[a] 
		if sbck==aux.Stringid(11579808,1) then 
			local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end 
		if sbck==aux.Stringid(11579808,2) then 
			local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE) 
			local tc=g:GetFirst() 
			while tc do 
			local exg=Duel.GetMatchingGroup(c11579808.exgfil,tp,0,LOCATION_MZONE,nil,tc:GetSequence()) 
			g:Merge(exg)
			tc=g:GetNext()
			end 
			Duel.SendtoGrave(g,REASON_EFFECT)
		end 
		if sbck==aux.Stringid(11579808,3) then 
			local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
			local dg=g:RandomSelect(tp,1) 
			Duel.SendtoGrave(dg,REASON_EFFECT)
		end 
		if sbck==aux.Stringid(11579808,4) then 
			local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil) 
			Duel.ConfirmCards(tp,g) 
			local dg=g:Select(tp,1,1,nil) 
			Duel.SendtoGrave(dg,REASON_EFFECT)
		end 
		a=a+1   
		end 
	end 
end 








