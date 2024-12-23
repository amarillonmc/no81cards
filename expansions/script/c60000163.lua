--亚里沙·回音
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000163)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--zone limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MUST_USE_MZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(cm.zonelimit)
	c:RegisterEffect(e0)
	--spsummon cost
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_SPSUMMON_COST)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCost(cm.splimit)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EFFECT_SUMMON_COST)
	e02:SetCost(cm.sumlimit)
	c:RegisterEffect(e02)
	local e03=e01:Clone()
	e03:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e03)
	
	local e05=Effect.CreateEffect(c)
	e05:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e05:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e05:SetCode(EVENT_SUMMON_SUCCESS)
	e05:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e05:SetOperation(cm.tokenop)
	c:RegisterEffect(e05)
	local e06=e05:Clone()
	e06:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e06)
	local e07=e05:Clone()
	e07:SetCode(EVENT_FLIP)
	c:RegisterEffect(e07)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e9=e1:Clone()
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(nil)
	e9:SetCountLimit(1)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(cm.tttcon)
	c:RegisterEffect(e9)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(cm.actcon)
	e2:SetOperation(cm.actop) 
	c:RegisterEffect(e2) 
	
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(cm.bkop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
end
--random
function getrand()
	local result=0
	local g=Duel.GetDecktopGroup(0,5)
	local tc=g:GetFirst()
	while tc do
		result=result+tc:GetCode()
		tc=g:GetNext()
	end
	math.randomseed(result)
end
function cm.tttcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),60000163)
end
function cm.spfilter(c)
	return aux.IsCodeListed(c,60000163) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:GetType()~=TYPE_SPELL
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if not tc then return end
	local dg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local uc=dg:SelectUnselect(nil,tp,false,false,1,1)
	if uc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ConfirmCards(1-tp,uc)
		return true
	else return false end
end
function cm.limitfil(c,e,tp)
	return c:IsCode(60000169) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.zonelimit(e)
	local tp=e:GetHandlerPlayer()
	local zone=0
	for i=0,3 do
		if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,1<<i)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,1<<(i+1))>0 then
			zone=zone|(1<<i)
		end
	end
	return zone
end
function cm.splimit(e,c,tp)
	local zone_check=false
	for i=0,3 do
		if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,1<<i)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,1<<(i+1))>0 then
			zone_check=true
		end
	end
	if not zone_check or Duel.GetLocationCount(tp,LOCATION_MZONE)<2   
	or not Duel.IsExistingMatchingCard(cm.limitfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) or not Duel.IsPlayerCanSpecialSummonCount(tp,2)
	or Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	return true
end
function cm.sumlimit(e,c,tp)
	local c=e:GetHandler()
	local zone_check=false
	local a=c:GetTributeRequirement()
	for i=0,3 do
		if Duel.GetFieldCard(tp,LOCATION_MZONE,i) then
			if not Duel.GetFieldCard(tp,LOCATION_MZONE,i):IsReleasable(c) or a==0 or Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,1<<(i+1))==0 then
			else
				zone_check=true
			end
		else
			if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,1<<i)==0 or Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,1<<(i+1))==0 then 
			else
				zone_check=true
			end
		end
	end
	if not zone_check  
	or not Duel.IsExistingMatchingCard(cm.limitfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) or not Duel.IsPlayerCanSpecialSummonCount(tp,1) then return false end
	return true
end
function cm.tokenop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(e:GetHandler():GetSequence()+1)))>0
		and Duel.IsExistingMatchingCard(cm.limitfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		local token=Duel.GetMatchingGroup(cm.limitfil,tp,LOCATION_EXTRA,0,nil,e,tp):RandomSelect(tp,1):GetFirst()
		local seq=e:GetHandler():GetSequence()
		local seq_i=(1<<(seq+1))
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK,seq_i)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e3,true)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		token:RegisterEffect(e4,true)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e5,true)
		local e6=e2:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
		Duel.Hint(24,0,aux.Stringid(60000163,4))
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	end
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,60000163) and c:IsAbleToHand() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:GetType()~=TYPE_SPELL
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local i=math.random(6,8)
		Duel.Hint(24,0,aux.Stringid(60000163,i))
	end
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp) 
	return ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and aux.IsCodeListed(re:GetHandler(),60000163) and (re:GetHandler():IsType(TYPE_SPELL) or re:GetHandler():IsType(TYPE_TRAP)) and re:GetHandler():GetType()~=TYPE_SPELL 
end 
function cm.actop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,m) 
	Duel.SetChainLimit(cm.chainlm)
	local i=math.random(6,8)
	Duel.Hint(24,0,aux.Stringid(60000163,i))
end
function cm.chainlm(e,rp,tp)
	return tp==rp 
end 
function cm.bkfil(c)
	return c:IsCode(60000169) and c:IsAbleToHand()
end
function cm.bkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.bkfil,tp,LOCATION_GRAVE,0,nil)
	if #g==0 or not c:IsAbleToHand() or not c:IsRelateToEffect(e) then return end
	local bg=Group.FromCards(c,g:RandomSelect(tp,1):GetFirst())
	Duel.SendtoHand(bg,nil,REASON_EFFECT)
end
function cm.tttfil(c)
	return c:IsCode(60000169) and c:IsFaceup()
end
function cm.efilter(e,re)
	local utrue=false
	if Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),60000163) and Duel.IsExistingMatchingCard(cm.tttfil,tp,LOCATION_MZONE,0,1,nil) then utrue=true end
	if e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated() and utrue then Duel.Hint(HINT_CARD,0,60000178) end
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated() and utrue
end