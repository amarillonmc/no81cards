--缘
local m=130006046
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,130006046)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c130006046.sptg)
	e1:SetOperation(c130006046.spop)
	c:RegisterEffect(e1)
	--ge
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c130006046.gecon)
	e2:SetTarget(c130006046.getg)
	e2:SetOperation(c130006046.geop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c130006046.tecon)
	e3:SetOperation(c130006046.teop)
	Duel.RegisterEffect(e3,tp)
end

function c130006046.tecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc and eg:GetFirst()==c and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE)
end
function c130006046.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,130006046)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(130006046,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetCondition(c130006046.eecon)
	e1:SetOperation(c130006046.eeop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
function c130006046.eecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c130006046.eeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,130006046)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end


function c130006046.gesfilter(c,col)
	return col==aux.GetColumn(c)
end
function c130006046.gecon(e,tp,eg,ep,ev,re,r,rp)
	local col=aux.GetColumn(e:GetHandler())
	return col and eg:IsExists(c130006046.gesfilter,1,e:GetHandler(),col) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c130006046.tgfilter(c,e)
	local cg=c:GetColumnGroup()
	local ccg=cg:Filter(Card.IsCanBeEffectTarget,nil,e)
	return ccg:GetCount()>0 and c:IsCanBeEffectTarget(e)
end
function c130006046.getg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c130006046.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c130006046.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
	local c=g1:GetFirst()
	local g2=c:GetColumnGroup()
	local g=g2:FilterSelect(tp,c130006046.tgfilter,1,1,nil,e)
	Duel.SetTargetCard(g)
end
function c130006046.geop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1 and tc2 and tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then
		tc1:SetCardTarget(tc2)
		tc1:RegisterFlagEffect(130006046,RESET_EVENT+RESETS_STANDARD,0,1,1)
		tc2:RegisterFlagEffect(130006046,RESET_EVENT+RESETS_STANDARD,0,1,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCondition(c130006046.descon)
		e1:SetOperation(c130006046.desop)
		tc1:RegisterEffect(e1)
		tc2:RegisterEffect(e1)
	end
end
function c130006046.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=c:GetCardTarget()
	local gc=Group.__band(eg,tg)
	return gc:GetCount()>0 and c:GetFlagEffect(130006046)>0
end
function c130006046.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=c:GetCardTarget()
	local gc=Group.__band(eg,tg)
--  c:ResetFlagEffect(130006046)
--  gc:ResetFlagEffect(130006046)
	Duel.Destroy(c,REASON_EFFECT)
end


function c130006046.spfilter(c,e,tp)
	return aux.IsCodeListed(c,130006046) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c130006046.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c130006046.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c130006046.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c130006046.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end












