local m=15004098
local cm=_G["c"..m]
cm.name="超机怪虫·启示红核虫"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,cm.lcheck)
	c:EnableReviveLimit()
	--target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.cecon)
	e1:SetTarget(cm.cetg)
	e1:SetOperation(cm.ceop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x104)
end
function cm.target(e,c)
	return c:IsFacedown()
end
function cm.cecon(e,tp,eg,ep,ev,re,r,rp)
	if e==re or rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc
end
function cm.cefilter(c)
	return ((c:IsFaceup() and c:IsCanTurnSet()) or c:IsFacedown()) and c:IsCanChangePosition()
end
function cm.cetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.cefilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cefilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.cefilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local cg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		local ctc=cg:GetFirst()
		local pos=tc:GetPosition()
		local tpos=0
		if bit.band(pos,POS_FACEDOWN_DEFENSE)==0 then tpos=tpos+POS_FACEDOWN_DEFENSE end
		if bit.band(pos,POS_FACEUP_DEFENSE)==0 then tpos=tpos+POS_FACEUP_DEFENSE end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSITION)
		local ttpos=Duel.SelectPosition(tp,tc,tpos)
		if Duel.ChangePosition(tc,ttpos)~=0 and ctc and ctc~=tc and Duel.CheckChainTarget(ev,tc) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.ChangeTargetCard(ev,Group.FromCards(tc))
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousPosition(POS_FACEUP)
end
function cm.spfilter1(c,e,tp)
	return c:IsSetCard(0x104) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
		and Duel.IsExistingTarget(cm.spfilter2,tp,LOCATION_GRAVE,0,1,c,c:GetCode(),e,tp)
end
function cm.spfilter2(c,cd,e,tp)
	return not c:IsCode(cd) and c:IsSetCard(0x104) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(cm.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,cm.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,cm.spfilter2,tp,LOCATION_GRAVE,0,1,1,tc1,tc1:GetCode(),e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or ft<=0 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if ft<g:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end