--Ratatoskr 椎崎雏子
local m=33401406
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
 --disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con2)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	 local e1=Effect.CreateEffect(e:GetHandler())
	 e1:SetType(EFFECT_TYPE_SINGLE)
	 e1:SetCode(EFFECT_PUBLIC)
	 e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	 e:GetHandler():RegisterEffect(e1)
e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,66)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetCode(EVENT_TO_GRAVE)
		e3:SetLabel(ac)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetCondition(cm.damcon)
		e3:SetTarget(cm.thtg)
		e3:SetOperation(cm.damop)
		Duel.RegisterEffect(e3,tp) 
end
function cm.filter1(c,e,tp,re)
local ac=e:GetLabel()
	return ((c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp) or (c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp)))
		and c:IsCode(ac)  and c:IsType(TYPE_MONSTER) 
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_HAND)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and cm.filter1(chkc,e,tp,re) end
	if chk==0 then return eg:IsExists(cm.filter1,1,nil,e,tp,re) end
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)  and c:IsLocation(LOCATION_HAND) and c:IsDiscardable() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
		local tg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,2,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end

function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and  Duel.GetCurrentChain()==0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_TO_GRAVE)
		e3:SetLabel(ac)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetTarget(cm.dmtg)
		e3:SetOperation(cm.dmop)
		Duel.RegisterEffect(e3,tp) 
end
function cm.filter2(c,e,tp,re)
local ac=e:GetLabel()
	return ((c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp) or (c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp))) and c:IsPreviousLocation(LOCATION_ONFIELD) and  c:GetPreviousControler()==tp
		and c:IsCode(ac)  and c:IsType(TYPE_MONSTER) 
end
function cm.dmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and cm.filter2(chkc,e,tp,re) end
	if chk==0 then return eg:IsExists(cm.filter2,1,nil,e,tp,re)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function cm.dmop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if  c:IsLocation(LOCATION_GRAVE)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		   local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end

