local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,33900648)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCode(97811903)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ANNOUNCE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(s.atcon)
	e3:SetTarget(s.attg)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
end
function s.spfilter(c)
	return aux.IsCodeListed(c,33900648) and c:IsAbleToDeckAsCost()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,2,c)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,2,2,c)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_SPSUMMON)
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local attchk=0
	local tc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if tc and tc:IsCode(33900648) and not tc:IsDisabled() and not Duel.IsPlayerAffectedByEffect(1-tp,97811903) then
		if Duel.IsPlayerAffectedByEffect(1-tp,6089145) then
			attchk=ATTRIBUTE_LIGHT|ATTRIBUTE_DARK|ATTRIBUTE_EARTH|ATTRIBUTE_WATER|ATTRIBUTE_FIRE|ATTRIBUTE_WIND
		else
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			for tc in aux.Next(g) do attchk=attchk|tc:GetAttribute() end
		end
	end
	if chk==0 then return attchk>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,attchk)
	e:SetLabel(rc)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetLabel(e:GetLabel())
	e1:SetCondition(s.limitcon)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function s.limitcon(e)
	local tp=e:GetHandlerPlayer()
	local tc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if not tc or not tc:IsCode(33900648) or tc:IsDisabled() or Duel.IsPlayerAffectedByEffect(1-tp,97811903) then return false end
	return Duel.IsPlayerAffectedByEffect(1-tp,6089145) or Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsAttribute),tp,0,LOCATION_MZONE,nil,e:GetLabel())
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsAttribute(e:GetLabel())
end
