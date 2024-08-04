--碧之汐雏 幻惑之闪
local cm,m=GetID()
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--trigger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.pspcon)
	e1:SetTarget(cm.psptg)
	e1:SetOperation(cm.pspop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(aux.TRUE)
	c:RegisterEffect(e3)
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(m,5))
	e5:SetCode(EVENT_MOVE)
	e5:SetCondition(cm.pspcon2)
	c:RegisterEffect(e5)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetTarget(cm.psptg2(11451911))
	c:RegisterEffect(e4)
	local e6=e3:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetTarget(cm.psptg2(11451913))
	c:RegisterEffect(e6)
	local e8=e5:Clone()
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetTarget(cm.psptg2(11451915))
	c:RegisterEffect(e8)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_HAND
end
function cm.spfilter0(c,loc)
	return c:IsPreviousLocation(loc) and not (c:IsLocation(loc) and c:IsControler(c:GetPreviousControler()))
end
function cm.pspcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter0,1,nil,LOCATION_DECK) and (not eg:IsContains(e:GetHandler()) or e:GetHandler():IsLocation(LOCATION_HAND))
end
function cm.thfilter(c,e,tp,...)
	local tab={...}
	for _,code in ipairs(tab) do
		if c:GetOriginalCode()==code and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if c:IsLocation(LOCATION_EXTRA) then
				return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
			else
				return Duel.GetMZoneCount(tp)>0
			end
		end
	end
	return false
end
function cm.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tab0={11451911,11451913,11451915}
	local tab={}
	for _,code in ipairs(tab0) do
		if c:GetFlagEffect(code)>0 then tab[#tab+1]=code end
	end
	if chk==0 then
		return #tab>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,table.unpack(tab))
	end
	e:SetLabel(table.unpack(tab))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.psptg2(code)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then
					c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
					return false
				end
			end
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp)
	local tab={e:GetLabel()}
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	if ft1>0 then loc=loc|LOCATION_GRAVE end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,loc,0,nil,e,tp,table.unpack(tab))
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Auxiliary.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,ft2,ft)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,g:GetClassCount(Card.GetOriginalCode))
	Auxiliary.GCheckAdditional=nil
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil)
end
function cm.thfilter2(c)
	return c:IsSetCard(0x9977) and c:IsAbleToHand()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	if Duel.GetCurrentChain()>1 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	else e:SetProperty(EFFECT_FLAG_DELAY) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local rg=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if Duel.SendtoHand(rg,nil,REASON_EFFECT)>0 then Duel.ConfirmCards(1-tp,rg) end
	end
end