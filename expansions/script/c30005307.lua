--染魔之地
local m=30005307
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	e1:SetCondition(cm.hcon)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_FZONE+LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--Effect 3 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_FZONE+LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.tcon)
	e3:SetTarget(cm.ttg)
	c:RegisterEffect(e3)
end
--Effect 1
function cm.hcon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)  
end
--Effect 2
function cm.sp(c,e,tp)
	if not c:IsType(TYPE_TRAP) then return false end
	local b1=c:IsType(TYPE_CONTINUOUS)
	local b2=cm.spf(c,e,tp,tp)
	local b3=cm.spf(c,e,tp,1-tp)
	return c:IsFaceupEx() and b1 and (b2 or b3)
end
function cm.spf(c,e,tp,sp)
	local ft=Duel.GetLocationCount(sp,LOCATION_MZONE)
	local b1=Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPES_NORMAL_TRAP_MONSTER,500,0,6,RACE_FIEND,ATTRIBUTE_FIRE,POS_FACEUP,sp) 
	return ft>0 and b1 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.sp,tp,loc,0,nil,e,tp)
	if chk==0 then return ft>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,loc)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED 
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.sp),tp,loc,0,nil,e,tp)
	if  #g==0 then return end
	local ct=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,ct,nil)
	if #sg==0 then return false end
	for tc in aux.Next(sg) do  
		local b1=cm.spf(tc,e,tp,tp)
		local b2=cm.spf(tc,e,tp,1-tp)
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,1)})
		if not b1 and not b2 then return end
		if op==1 then 
			cm.spp(e,tp,tc,tp)
		else
			cm.spp(e,tp,tc,1-tp)
		end
	end
	Duel.SpecialSummonComplete()
end
function cm.spp(e,tp,tc,sp)
	tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP,ATTRIBUTE_FIRE,RACE_FIEND,6,500,0)
	Duel.SpecialSummonStep(tc,0,tp,sp,true,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(0)
	tc:RegisterEffect(e2,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(6)
	tc:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(ATTRIBUTE_FIRE)
	tc:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_RACE)
	e5:SetValue(RACE_FIEND)
	tc:RegisterEffect(e5,true)
	local e12=Effect.CreateEffect(e:GetHandler())
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e12:SetValue(1)
	e12:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e12,true)
	local e13=Effect.CreateEffect(e:GetHandler())
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e13:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e13,true)
end
--Effect 3
function cm.thcf(c,tp,rp)
	local b1=bit.band(c:GetPreviousTypeOnField(),TYPE_CONTINUOUS)~=0 and bit.band(c:GetPreviousTypeOnField(),TYPE_TRAP)~=0
	local b2=bit.band(c:GetPreviousRaceOnField(),RACE_FIEND)~=0 and c:GetPreviousLevelOnField()==6
	local b3=c:IsPreviousControler(tp) 
	local b4=c:GetReasonPlayer()==1-tp
	local b5=rp==1-tp
	return (b1 or b2) and b3 and (b4 or b5)
end
function cm.tf(c)
	local b1=c:IsType(TYPE_CONTINUOUS)
	local b2=c:IsType(TYPE_TRAP)
	local b3=c:IsRace(RACE_FIEND)
	local b4=c:IsLevel(6)
	return c:IsFaceupEx() and c:IsAbleToHand() and ((b1 and b2) or (b3 and b4))
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thcf,1,nil,tp,rp)
end 
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local bt=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local dk= at>bt and Duel.IsPlayerCanDraw(tp,at-bt)
	local tg=Duel.GetMatchingGroup(cm.tf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return dk or #tg>0 or #dg>0 end
	local op=aux.SelectFromOptions(tp,
			{dk,aux.Stringid(m,2)},
			{#tg>0,aux.Stringid(m,3)},
			{#dg>0,aux.Stringid(m,4)})
	if op==1 then
		local ct=at-bt
		e:SetCategory(CATEGORY_DRAW)
		e:SetCategory(e:GetCategory()|EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(cm.draw)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(ct)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)  
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetOperation(cm.top)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)  
	else 
		e:SetCategory(CATEGORY_DESTROY)
		e:SetOperation(cm.dop)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)   
	end
end
function cm.draw(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local at=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local bt=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct=at-bt
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tf),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if not tc or tc==nil then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
