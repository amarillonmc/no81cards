-- this card is a library ~~~
VHisc_ESP=VHisc_ESP or {}
VHisc_CardType=222

--------------------------------spsummon proc-----------------------------------------
function VHisc_ESP.SpProc(ec,cid)
	local e0=Effect.CreateEffect(ec)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK)
	e0:SetCountLimit(1,cid+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(VHisc_ESP.spcon)
	e0:SetTarget(VHisc_ESP.sptg)
	e0:SetOperation(VHisc_ESP.spop)
	e0:SetValue(SUMMON_VALUE_SELF)
	ec:RegisterEffect(e0)
end
function VHisc_ESP.spfilter(c)
	return c:IsSetCard(0x3327) and c:IsFaceup() and (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost())
end
function VHisc_ESP.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(VHisc_ESP.spfilter,tp,LOCATION_REMOVED,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 and (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or (VHisc_CardType==222 and c:IsLocation(LOCATION_DECK) and Duel.GetFlagEffect(tp,33201550)==0))
end
function VHisc_ESP.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(VHisc_ESP.spfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:Select(tp,1,1,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)   
		if c:IsLocation(LOCATION_DECK) then Duel.RegisterFlagEffect(tp,33201550,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1) end
		return true
	else return false end
end
function VHisc_ESP.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,nil,REASON_SPSUMMON)
	g:DeleteGroup()
end

--------------------------------rmcard-----------------------------------------
function VHisc_ESP.RMC(ec,cid,cate)
	local e1=Effect.CreateEffect(ec)
	e1:SetDescription(aux.Stringid(cid,0))
	e1:SetCategory(cate)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(cid)
	e1:SetCost(VHisc_ESP.rmcost)
	e1:SetTarget(VHisc_ESP.rmtg)
	e1:SetOperation(VHisc_ESP.rmop)
	ec:RegisterEffect(e1)
end
function VHisc_ESP.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function VHisc_ESP.rmfilter(c)
	return c:IsSetCard(0x3327) and c:IsAbleToRemove()
end
function VHisc_ESP.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,nil,nil)>3 end
end
function VHisc_ESP.rmop(e,tp,eg,ep,ev,re,r,rp)
	local cid=e:GetLabel()
	local cs=_G["c"..cid]
	local c=e:GetHandler()
	local ct=0
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,nil,nil)>3 then
		Duel.ConfirmDecktop(tp,4)
		local rmg=Duel.GetDecktopGroup(tp,4):Filter(VHisc_ESP.rmfilter,nil)
		if rmg:GetCount()>0 then
			ct=Duel.Remove(rmg,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
		if ct>0 then cs.op(c,e,tp,ct) end
	end
end

-------------------------card effect------------------------------
local m=33201550
local cm=_G["c"..m]
if not cm then return end
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.matfilter,2,true)
	--redirect
	aux.AddBanishRedirect(c)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.rmtarget)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	--todeck
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,2))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_TO_DECK)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,m+10000)
	e0:SetCondition(cm.tdcon)
	e0:SetTarget(cm.tdtg)
	e0:SetOperation(cm.tdop)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.matfilter(c)
	return c:IsSetCard(0x3327) and not c:IsType(TYPE_FUSION)
end

--e3
function cm.rmtarget(e,c)
	return c:IsType(TYPE_MONSTER)
end

--e0
function cm.ffilter(c,e,tp)
	return c:IsSetCard(0x3327) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 or Duel.GetMatchingGroupCount(cm.ffilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)<1 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.ffilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		for tc in aux.Next(g) do
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(LOCATION_REMOVED)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				tc:RegisterEffect(e1,true)
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
			end
		end
		Duel.SpecialSummonComplete()
	end
end

--e1
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup()) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_REMOVED) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_REMOVED,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_REMOVED,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end