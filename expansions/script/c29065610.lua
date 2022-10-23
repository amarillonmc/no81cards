--RO635·审判者
function c29065610.initial_effect(c)
	c:SetSPSummonOnce(29065610)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c29065610.lcheck)
	c:EnableReviveLimit()
	--Equip
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c29065610.eqcon)
	e1:SetOperation(c29065610.eqop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065610,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c29065610.chcon)
	e2:SetTarget(c29065610.chtg)
	e2:SetOperation(c29065610.chop)
	c:RegisterEffect(e2)
end
function c29065610.lfilter(c)
	return c:IsLinkRace(RACE_MACHINE) and c:IsLinkSetCard(0x87ad)
end
function c29065610.lcheck(g)
	return g:IsExists(c29065610.lfilter,1,nil)
end
function c29065610.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterial():Filter(Card.IsSetCard,nil,0x7ad):GetCount()>0
end
function c29065610.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial():Filter(Card.IsSetCard,nil,0x7ad)
	if g:GetCount()>Duel.GetLocationCount(tp,LOCATION_SZONE) then
	g=g:Select(tp,Duel.GetLocationCount(tp,LOCATION_SZONE),Duel.GetLocationCount(tp,LOCATION_SZONE),nil)
	end
	local tc=g:GetFirst()
	while tc do 
	Duel.Equip(tp,tc,c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(c)
	e1:SetValue(c29065610.eqlimit)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
end
function c29065610.eqlimit(e,c)
	return c==e:GetLabelObject() 
end
function c29065610.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local cseq=c:GetSequence()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	local b1=c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) and (cseq==5 and seq==0 or cseq==6 and seq==2)
	local b2=c:IsLinkMarker(LINK_MARKER_BOTTOM) and (cseq==5 and seq==1 or cseq==6 and seq==3)
	local b3=c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) and (cseq==5 and seq==2 or cseq==6 and seq==4)
	return rp==tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and rc:IsSetCard(0x7ad) and (b1 or b2 or b3)
end
function c29065610.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ftg=re:GetTarget()
	if chkc then return ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk) end
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c29065610.chop(e,tp,eg,ep,ev,re,r,rp)
	local fop=re:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
