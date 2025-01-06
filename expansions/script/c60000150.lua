--七实·芒星之迹
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000150)
	--c:SetUniqueOnField(1,0,m)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
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
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(cm.regop)
	c:RegisterEffect(e5)
	
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetCondition(cm.immcon)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.immcon)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
end
cm.isMC=true
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
function cm.spcon(e,c)
	local c=e:GetHandler()
	local b1=false
	local b2=false
	if c:IsLocation(LOCATION_DECK) and c:GetFlagEffect(m)~=0 
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 then b1=true end
	if (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToDeckAsCost() then b2=true end
	if c==nil then return true end
	return b1 or b2
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local c=e:GetHandler()
	local b1=false
	local b2=false
	if c:IsLocation(LOCATION_DECK) and c:GetFlagEffect(m)~=0 
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 then b1=true end
	if (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToDeckAsCost() then b2=true end
	if b2 then
		Duel.ConfirmCards(1-tp,c)
		if Duel.SendtoDeck(c,nil,2,REASON_SPSUMMON)~=0 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PREDRAW)
			e3:SetCountLimit(1)
			e3:SetRange(LOCATION_DECK)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetOperation(cm.retop)
			c:RegisterEffect(e3)
		end
		return false
	elseif b1 then
		return true
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	e:Reset()
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,60000150) and c:IsAbleToHand() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
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
		local i=math.random(7,14)
		Duel.Hint(24,0,aux.Stringid(60000150,i))
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetOwner()
	local eg=c:GetEquipGroup()
	if #eg==0 then return end
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(m+10000000,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	local og=Duel.GetMatchingGroup(cm.cfil1,tp,LOCATION_MZONE,0,nil)
	for oc in aux.Next(og) do
		oc:RegisterFlagEffect(m+20000000,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetCondition(cm.eqcon)
	e3:SetOperation(cm.eqop)
	Duel.RegisterEffect(e3,tp)
end
function cm.cfil1(c)
	return c:IsCode(60000150) and c:IsFaceup()
end
function cm.cfil2(c)
	return c:GetOriginalCode(60000150) and c:IsFaceup() and c:GetFlagEffect(m+20000000)==0
end
function cm.cfil3(c)
	return c:GetFlagEffect(m+10000000)~=0 and not c:IsForbidden()
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp,tc)
	return Duel.IsExistingMatchingCard(cm.cfil2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local tc=Duel.GetMatchingGroup(cm.cfil2,tp,LOCATION_MZONE,0,nil):GetFirst()
	local eg=Duel.GetMatchingGroup(cm.cfil3,tp,LOCATION_GRAVE,0,nil)
	local s=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local num=math.min(#eg,s)
	if num>0 then
		Duel.Hint(HINT_CARD,0,m)
		local teg=Group.CreateGroup()
		if num~=#eg then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			teg:Merge(eg:Select(tp,num,num,nil))
		else teg:Merge(eg) end
		for ec in aux.Next(teg) do
			if Duel.Equip(tp,ec,tc,true) then
				local e1=Effect.CreateEffect(ec)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetLabelObject(tc)
				e1:SetValue(cm.eqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				ec:RegisterEffect(e1)
			end
		end
		Duel.EquipComplete()
	end
	local ng=Duel.GetMatchingGroup(aux.TRUE,tp,0xff,0,nil)
	for nc in aux.Next(ng) do
		if nc:GetFlagEffect(m+10000000)>0 then nc:ResetFlagEffect(m+10000000) end
		if nc:GetFlagEffect(m+20000000)>0 then nc:ResetFlagEffect(m+20000000) end
	end
	Duel.Hint(24,0,aux.Stringid(60000150,1))
	e:Reset()
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function cm.immcon(e)
	return e:GetHandler():GetEquipCount()~=0
end












