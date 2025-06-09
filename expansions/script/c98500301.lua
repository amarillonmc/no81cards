--创造神 哈拉克提
local m=98500301
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,10000010,10000020,10000000)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--link limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetTarget(cm.lklimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.srtg)
	e2:SetOperation(cm.srop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+100)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--赋予神之进化
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+101)
	e4:SetCondition(cm.thcon)
	e4:SetOperation(cm.xgop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function cm.lklimit(e,c)
	if not c then return false end
	return c:IsRace(RACE_DIVINE) or c:IsAttribute(ATTRIBUTE_DIVINE)
end
function cm.matfilter(c)
	return c:IsLinkRace(RACE_DIVINE)
end
function cm.tgfilter2(c)
	return c:IsAbleToGrave() and c:IsRace(RACE_DIVINE) and c:IsReleasable()
end
function cm.srfilter(c)
	return (aux.IsCodeListed(c,10000000) or aux.IsCodeListed(c,10000010) or aux.IsCodeListed(c,10000020) or c:IsCode(5253985,7373632,59094601,39913299,79339613,42469671,85758066,85182315,79868386,32247099,269012,10000000,10000010,10000020,79387392)) and c:IsAbleToHand()
	
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.tgfilter2,tp,LOCATION_MZONE,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	--splimit
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetTargetRange(1,0)
	e0:SetTarget(cm.splimit)
	Duel.RegisterEffect(e0,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(cm.tgfilter2,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectMatchingCard(tp,cm.tgfilter2,tp,LOCATION_MZONE,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Release(sg,REASON_EFFECT)
		end
	end
end
function cm.splimit(e,c)
	return c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsLocation(LOCATION_HAND) and c:IsLevel(12)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(98500311)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.xgop(e,tp,eg,ep,ev,re,r,rp)
		 local lg=e:GetHandler():GetLinkedGroup()
		 local tc1=lg:GetFirst()
		 while tc1 do
		 tc1:RegisterFlagEffect(7373632,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(7373632,0))   
		 tc1=lg:GetNext()  
	end   
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(cm.cfilter2,1,nil,lg)
end
function cm.cfilter2(c,lg)
	return c:IsRace(RACE_DIVINE) and lg:IsContains(c)
end
function cm.lkfilter(c,type)
	return c:IsFaceup() and c:IsType(type)
end