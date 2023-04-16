--虹彩偶像 米娅·泰勒
function c9910764.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910764)
	e1:SetCondition(c9910764.spcon)
	e1:SetTarget(c9910764.sptg)
	e1:SetOperation(c9910764.spop)
	c:RegisterEffect(e1)
	--extra tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910765)
	e2:SetTarget(c9910764.tgtg)
	e2:SetOperation(c9910764.tgop)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c9910764.recon)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c9910764.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c9910764.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910764.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x5951) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910764.fselect(g,tp,c)
	local res=true
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then
		res=g:GetCount()<=1
	end
	return res and g:IsContains(c)
end
function c9910764.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9910764.spfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c9910764.fselect,false,1,2,tp,e:GetHandler())
	if sg:GetCount()>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
end
function c9910764.spellfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c9910764.tfilter(c,typ)
	return c:IsType(typ) and c:IsFaceup()
end
function c9910764.tgfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsAbleToGrave()
end
function c9910764.tgselect(g,typ)
	if bit.band(typ,1)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_FUSION)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_FUSION)>1 then return false end
	if bit.band(typ,2)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)>1 then return false end
	if bit.band(typ,4)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_XYZ)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_XYZ)>1 then return false end
	if bit.band(typ,8)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_LINK)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_LINK)>1 then return false end
	return true
end
function c9910764.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local typ=0
	if Duel.IsExistingMatchingCard(c9910764.tfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_FUSION)
		and not Duel.IsExistingMatchingCard(c9910764.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_FUSION) then typ=typ+1 end
	if Duel.IsExistingMatchingCard(c9910764.tfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_SYNCHRO)
		and not Duel.IsExistingMatchingCard(c9910764.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_SYNCHRO) then typ=typ+2 end
	if Duel.IsExistingMatchingCard(c9910764.tfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_XYZ)
		and not Duel.IsExistingMatchingCard(c9910764.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ) then typ=typ+4 end
	if Duel.IsExistingMatchingCard(c9910764.tfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_LINK)
		and not Duel.IsExistingMatchingCard(c9910764.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_LINK) then typ=typ+8 end
	local g2=Duel.GetMatchingGroup(c9910764.tgfilter,tp,LOCATION_EXTRA,0,nil)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9910764.spellfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910764.spellfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and typ>0 and g2:CheckSubGroup(c9910764.tgselect,1,4,typ) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910764,0))
	local g=Duel.SelectTarget(tp,c9910764.spellfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c9910764.tgop(e,tp,eg,ep,ev,re,r,rp)
	local typ=0
	if Duel.IsExistingMatchingCard(c9910764.tfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_FUSION)
		and not Duel.IsExistingMatchingCard(c9910764.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_FUSION) then typ=typ+1 end
	if Duel.IsExistingMatchingCard(c9910764.tfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_SYNCHRO)
		and not Duel.IsExistingMatchingCard(c9910764.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_SYNCHRO) then typ=typ+2 end
	if Duel.IsExistingMatchingCard(c9910764.tfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_XYZ)
		and not Duel.IsExistingMatchingCard(c9910764.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ) then typ=typ+4 end
	if Duel.IsExistingMatchingCard(c9910764.tfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_LINK)
		and not Duel.IsExistingMatchingCard(c9910764.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_LINK) then typ=typ+8 end
	local g2=Duel.GetMatchingGroup(c9910764.tgfilter,tp,LOCATION_EXTRA,0,nil)
	if typ==0 or g2:GetCount()==0 then return end
	local sg=g2:SelectSubGroup(tp,c9910764.tgselect,false,1,4,typ)
	if sg:GetCount()==0 or Duel.SendtoGrave(sg,REASON_EFFECT)==0 then return end
	local g=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then g:AddCard(c) end
	if tc:IsRelateToEffect(e) then g:AddCard(tc) end
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c9910764.recon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetReasonPlayer()~=c:GetControler()
end
