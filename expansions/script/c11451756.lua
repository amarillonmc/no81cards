--逆汐击龙“幽影”
local cm,m=GetID()
function cm.initial_effect(c)
	--resp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.thfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToRemove()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,11451760)>0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local sa=c:IsLocation(LOCATION_HAND) and Duel.GetFlagEffect(tp,m+1)==0
	local sb=c:IsLocation(LOCATION_REMOVED) and Duel.GetFlagEffect(tp,m+10)==0
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and cm.desfilter(chkc,tp) end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) and (sa or sb) end
	if c:IsLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	elseif c:IsLocation(LOCATION_REMOVED) then
		Duel.RegisterFlagEffect(tp,m+10,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil)
end
function cm.costfilter(c)
	return c:IsSetCard(0x9977) and c:IsAbleToRemoveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sa=c:IsLocation(LOCATION_HAND) and Duel.GetFlagEffect(tp,m+1)==0
	local sb=c:IsLocation(LOCATION_REMOVED) and Duel.GetFlagEffect(tp,m+10)==0
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (sa or sb) end
	if c:IsLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	elseif c:IsLocation(LOCATION_REMOVED) then
		Duel.RegisterFlagEffect(tp,m+10,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Draw(tp,2,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end