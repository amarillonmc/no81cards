local cm,m,o=GetID()
function cm.initial_effect(c)
	c:SetSPSummonOnce(13000760)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,3,2,cm.sum1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
end

function cm.sum1(c)
	return c:IsSetCard(0xe09)
end
function cm.sfilter(c,p,seq,loc)
	local sseq=c:GetSequence()
	if c:IsControler(1-p) then
		return loc==LOCATION_MZONE and c:IsLocation(LOCATION_MZONE)
			and (sseq==5 and seq==3 or sseq==6 and seq==1)
	end
	if c:IsLocation(LOCATION_SZONE) then
		return sseq<5 and (sseq==seq or loc==LOCATION_SZONE and math.abs(sseq-seq)==1)
	end
	if sseq<5 then
		return sseq==seq or loc==LOCATION_MZONE and math.abs(sseq-seq)==1
	else
		return loc==LOCATION_MZONE and (sseq==5 and seq==1 or sseq==6 and seq==3)
	end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pt=c:GetOwner()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,1-tp)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,1-pt)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,1-pt)

	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetCountLimit(1)
	e9:SetOperation(cm.tgop)
	e9:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e9,1-pt)

	local g=Duel.GetMatchingGroup(cm.sfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,c,c:GetControler(),c:GetSequence(),c:GetLocation())
	local g2=c:GetColumnGroup()
	g:Merge(g2)
	Duel.Overlay(c, g)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectYesNo(tp, aux.Stringid(m,1))
	if op then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

