--天王数码兽 木偶兽
function c50223160.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c50223160.lcheck)
	c:EnableReviveLimit()
	--force mzone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_EXTRA)
	e1:SetCondition(c50223160.frccon)
	e1:SetValue(c50223160.frcval)
	c:RegisterEffect(e1)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,50223160)
	e1:SetTarget(c50223160.motg)
	e1:SetOperation(c50223160.moop)
	c:RegisterEffect(e1)
end
function c50223160.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==1
end
function c50223160.frccon(e)
	return e:GetHandler():GetSequence()>4
end
function c50223160.frcval(e,c,fp,rp,r)
	return e:GetHandler():GetLinkedZone() | 0x600060
end
function c50223160.cfilter(c,g)
	return c:IsControlerCanBeChanged() and g:IsContains(c)
end
function c50223160.motg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local cg=c:GetLinkedGroup()
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c50223160.cfilter(chkc,cg) end
	if chk==0 then return Duel.IsExistingTarget(c50223160.cfilter,tp,0,LOCATION_MZONE,1,nil,cg) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c50223160.cfilter,tp,0,LOCATION_MZONE,1,1,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c50223160.moop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local zone=bit.band(c:GetLinkedZone(),0x1f)
		Duel.GetControl(tc,tp,0,0,zone)
	end
end