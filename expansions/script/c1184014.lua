--饮食艺术·樱叶糕
function c1184014.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1184014,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c1184014.tg1)
	e1:SetOperation(c1184014.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1184014,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1184014)
	e2:SetCondition(c1184014.con2)
	e2:SetTarget(c1184014.tg2)
	e2:SetOperation(c1184014.op2)
	c:RegisterEffect(e2)
--
end
--
function c1184014.tfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c1184014.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1184014.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1184014.tfilter1,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c1184014.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c1184014.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
--
function c1184014.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x3e12)
end
function c1184014.tfilter2(c,e,tp,mg)
	return c:IsSynchroSummonable(nil,mg)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c1184014.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c1184014.tfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1184014.ofilter2(mg,tp,lc)
	return lc:IsSynchroSummonable(nil,mg,#mg-1,#mg-1)
		and Duel.GetLocationCountFromEx(tp,tp,mg,lc)>0
end
function c1184014.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1184014.tfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	if sg:GetCount()>0 then
		local lc=sg:GetFirst()
--
		local rg=mg:SelectSubGroup(tp,c1184014.ofilter2,false,1,#mg,tp,lc)
		lc:SetMaterial(rg)
		Duel.SendtoGrave(rg,REASON_SYNCHRO+REASON_MATERIAL)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetDescription(aux.Stringid(1184014,2))
		e2_1:SetType(EFFECT_TYPE_FIELD)
		e2_1:SetCode(EFFECT_SPSUMMON_PROC)
		e2_1:SetRange(LOCATION_EXTRA)
		e2_1:SetValue(SUMMON_TYPE_SYNCHRO)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		lc:RegisterEffect(e2_1,true)
		Duel.SpecialSummonRule(tp,lc,SUMMON_TYPE_SYNCHRO)
		e2_1:Reset()
--
	end
end
--
