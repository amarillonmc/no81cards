--联协武装 双子星
function c62501571.initial_effect(c)
	aux.AddEquipSpellEffect(c,true,true,Card.IsFaceup,nil)
	--grant
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)--
	e1:SetDescription(aux.Stringid(62501571,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(c62501571.xyztg)
	e1:SetOperation(c62501571.xyzop)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	ge1:SetRange(LOCATION_SZONE)
	ge1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ge1:SetTarget(c62501571.eftg)
	ge1:SetLabelObject(e1)
	c:RegisterEffect(ge1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--overlay
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c62501571.ovcon)
	e4:SetTarget(c62501571.ovtg)
	e4:SetOperation(c62501571.ovop)
	c:RegisterEffect(e4)
end
function c62501571.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsType(TYPE_EFFECT)
end
function c62501571.xyzfilter(c,mg,mc)
	return mg:CheckSubGroup(c62501571.xmcheck,1,#mg,c,mc)
end
function c62501571.xmcheck(g,exc,mc)
	return g:IsContains(mc) and exc:IsXyzSummonable(g,#g,#g)
end
function c62501571.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(c62501571.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,e:GetHandler())
	if chk==0 then return #exg>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c62501571.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(c62501571.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,c)
	if exg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=exg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local msg=mg:SelectSubGroup(tp,c62501571.xmcheck,false,1,#mg,sc,c)
		Duel.XyzSummon(tp,sc,msg,#msg,#msg)
	end
end
function c62501571.ovcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return ec and ec:GetReasonCard() and c:IsReason(REASON_LOST_TARGET) and ec:IsReason(REASON_MATERIAL) and ec:IsReason(REASON_XYZ)
end
function c62501571.xfilter(c)
	return c:IsSetCard(0xea3) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c62501571.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanOverlay() and Duel.IsExistingMatchingCard(c62501571.xfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c62501571.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local xc=Duel.SelectMatchingCard(tp,c62501571.xfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.HintSelection(Group.FromCards(xc))
	Duel.Overlay(xc,c)
end
