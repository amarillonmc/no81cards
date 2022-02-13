--终焉守护者 尼哥拉
local m=40010296
local cm=_G["c"..m]
cm.named_with_KeeperofArmageddon=1
function cm.KeeperofArmageddon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KeeperofArmageddon
end
function cm.KeeperofGenesis(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KeeperofGenesis
end
function cm.initial_effect(c)
	--Special Summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1) 
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.effcon)
	e2:SetOperation(cm.effop)
	c:RegisterEffect(e2)  
end
function cm.filter(c)
	return c:IsFaceup() and c:IsLevel(5)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	e:SetLabel(Duel.AnnounceLevel(tp,1,4,lv))
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct=e:GetLabel()
	local lv=tc:GetOriginalLevel()
	if not (c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)) then return end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(ct)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv-ct)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_SYNCHRO+REASON_XYZ)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():GetReasonCard():IsSetCard(0x52)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function cm.tgfilter(c)
	return ((cm.KeeperofGenesis(c) and c:IsType(TYPE_MONSTER)) or c:IsCode(40010304)) and c:IsAbleToHand()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end