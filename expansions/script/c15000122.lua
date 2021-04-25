local m=15000122
local cm=_G["c"..m]
cm.name="深渊之上"
function cm.initial_effect(c)
	--测 试 用
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_PREDRAW)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)  
	e1:SetCountLimit(1,15000122+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(cm.checkop)
	c:RegisterEffect(e1)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetLabelObject(c)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	Duel.RegisterEffect(e2,tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local y=0
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE) or Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_ACTIVATE) then y=y+1 end
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SUMMON) or Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SUMMON) then y=y+1 end
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON) or Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SPECIAL_SUMMON) then y=y+1 end
	return Duel.GetFlagEffect(tp,15000122)==0 and c and y~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON))
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local myx=0
	local yourx=0
	local myb1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SUMMON)
	if myb1 then
		myx=myx+1
	end
	local yourb1=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SUMMON)
	if yourb1 then
		yourx=yourx+1
	end
	local myb2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)
	if myb2 then
		myx=myx+1
	end
	local yourb2=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SPECIAL_SUMMON) 
	if yourb2 then
		yourx=yourx+1
	end
	local myb3=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)
	if myb3 then
		myx=myx+1
	end
	local yourb3=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_ACTIVATE)
	if yourb3 then
		yourx=yourx+1
	end
	local y=7
	local myop=7
	local yourop=7
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,15000122):GetFirst()
	if myx~=0 and yourx~=0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		y=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	if ((myx~=0 and yourx==0) or y==0) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if y==7 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			y=Duel.SelectOption(tp,aux.Stringid(m,0))
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		if   myb1 and myb2 and  myb3 then myop=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,6))
		elseif   myb1 and   myb2 and not myb3 then myop=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))
		elseif   myb1 and not myb2 and not myb3 then myop=Duel.SelectOption(tp,aux.Stringid(m,4))
		elseif not myb1 and  myb2 and   myb3 then myop=Duel.SelectOption(tp,aux.Stringid(m,5),aux.Stringid(m,6))+1
		elseif not myb1 and not myb2 and	 myb3 then myop=Duel.SelectOption(tp,aux.Stringid(m,6))+2
		elseif not myb1 and  myb2 and not myb3 then myop=Duel.SelectOption(tp,aux.Stringid(m,5))+1
		elseif   myb1 and not myb2 and   myb3 then
			myop=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,6))
			if myop==0 then myop=0 end
			if myop==1 then myop=2 end
		end
	end
	if ((myx==0 and yourx~=0) or y==1) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if y==7 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			y=Duel.SelectOption(tp,aux.Stringid(m,1))+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		if   yourb1 and  yourb2 and  yourb3 then yourop=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,6))
		elseif   yourb1 and  yourb2 and not yourb3 then yourop=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))
		elseif   yourb1 and not yourb2 and not yourb3 then yourop=Duel.SelectOption(tp,aux.Stringid(m,4))
		elseif not yourb1 and   yourb2 and  yourb3 then yourop=Duel.SelectOption(tp,aux.Stringid(m,5),aux.Stringid(m,6))+1
		elseif not yourb1 and not yourb2 and	 yourb3 then yourop=Duel.SelectOption(tp,aux.Stringid(m,6))+2
		elseif not yourb1 and   yourb2 and not yourb3 then yourop=Duel.SelectOption(tp,aux.Stringid(m,5))+1
		elseif   yourb1 and not yourb2 and   yourb3 then
			myop=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,6))
			if yourop==0 then yourop=0 end
			if yourop==1 then yourop=2 end
		end
	end

	if myx~=0 and yourx~=0 and myb2 and not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		y=Duel.SelectOption(tp,aux.Stringid(m,0))
	end
	if ((myx~=0 and yourx==0) or y==0) and not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if y==7 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			y=Duel.SelectOption(tp,aux.Stringid(m,0))
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		myop=Duel.SelectOption(tp,aux.Stringid(m,5))+1
	end
	local co=0
	local p=tp
	if myop==0 or yourop==0 then
		if yourop==0 and myop~=0 then p=1-tp end
		co=20
	end
	if myop==1 or yourop==1 then
		if yourop==1 and myop~=1 then p=1-tp end
		co=22
	end
	if myop==2 or yourop==2 then
		if yourop==2 and myop~=2 then p=1-tp end
		co=6
	end
	local count=0
	while Duel.IsPlayerAffectedByEffect(p,co)~=nil and count<=20 do
		local ae=Duel.IsPlayerAffectedByEffect(p,co)
--		Effect.Reset(ae)
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(15000122)
		e1:SetLabelObject(ae)
		if ae:GetCondition()~=nil then e1:SetCondition(ae:GetCondition()) end
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		ae:GetHandler():RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e2:SetCode(EVENT_PHASE+PHASE_END)
--		e2:SetCountLimit(1)
		e2:SetCondition(cm.givecon)
		e2:SetOperation(cm.giveop)
		e2:SetReset(RESET_PHASE+PHASE_STANDBY)
		Duel.RegisterEffect(e2,tp)
		ae:SetCondition(aux.FALSE)
		count=count+1
	end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	Duel.RegisterFlagEffect(tp,15000122,RESET_PHASE+PHASE_END,0,1)
end
function cm.givecon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,0xff,0xff,nil,15000122)
	return g:GetCount()~=0
end
function cm.giveop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,0xff,0xff,nil,15000122)
	local tc=g:GetFirst()
	while tc do
		local ae=tc:IsHasEffect(15000122)
		while ae do
			local be=ae:GetLabelObject()
			if ae:GetCondition() then
				be:SetCondition(ae:GetCondition())
			else
				be:SetCondition(aux.TRUE)
			end
			ae:Reset()
			ae=tc:IsHasEffect(15000122)
		end
		tc=g:GetNext()
	end
end