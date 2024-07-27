local m=15000670
local cm=_G["c"..m]
cm.name="报丧泣语·海鸣"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.sprcon)
	e0:SetOperation(cm.sprop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--disable or cannot
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.sprfilter(c,sc,tp)  
	return (c:IsSynchroType(TYPE_RITUAL) or c:IsSynchroType(TYPE_TUNER)) and c:GetLevel()~=0 and c:IsFaceup() and c:IsCanBeSynchroMaterial(sc) and Duel.IsExistingMatchingCard(cm.spr2filter,tp,LOCATION_MZONE,0,1,c,c:GetLevel(),sc)
end  
function cm.spr2filter(c,x,sc)
	return c:IsSynchroType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup() and c:IsLevel(sc:GetLevel()-x) and c:IsCanBeSynchroMaterial(sc) and not c:IsSynchroType(TYPE_TUNER)
end
function cm.sprcon(e)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()  
	return Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end  
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local tp=c:GetControler()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g1=Duel.SelectMatchingCard(tp,cm.sprfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	local x=g1:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g2=Duel.SelectMatchingCard(tp,cm.spr2filter,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),x,c)
	g1:Merge(g2)
	c:SetMaterial(g1) 
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	Duel.SendtoGrave(g1,REASON_COST)
	e:SetType(EFFECT_TYPE_FIELD)
	Debug.Message("Her cries, call forth the storm.")
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	g:GetFirst():RegisterFlagEffect(15000670,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsImmuneToEffect(e) then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not tc:IsLocation(LOCATION_ONFIELD) then return end
	if tc:GetFlagEffect(15000670)==0 then return end
	c:SetCardTarget(tc)
	if tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetCondition(cm.rcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	if tc:IsFacedown() then
		if tc:IsType(TYPE_MONSTER) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
			e2:SetCondition(cm.rcon)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			e3:SetCondition(cm.rcon)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetValue(1)
			tc:RegisterEffect(e3)
		end
	end
end
function cm.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function cm.spfilter(c,re)  
	return c:IsReason(REASON_COST) and re:IsActivated() and ((re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)) or re:GetHandler():IsCode(15000661))
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil,re)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end