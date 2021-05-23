--星辉观星者 阿斯忒西亚
function c9910601.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910601,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9910601.spcon)
	e1:SetTarget(c9910601.sptg)
	e1:SetOperation(c9910601.spop)
	c:RegisterEffect(e1)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910601.atkcon)
	e2:SetCost(c9910601.atkcost)
	e2:SetOperation(c9910601.atkop)
	c:RegisterEffect(e2)
end
function c9910601.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end
function c9910601.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910601.cfilter,1,nil,tp)
end
function c9910601.tfilter(c,typ)
	return c:IsType(typ) and c:IsFaceup()
end
function c9910601.tgfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsAbleToGrave()
end
function c9910601.tgselect(g,typ)
	if bit.band(typ,1)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_FUSION)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_FUSION)~=1 then return false end
	if bit.band(typ,2)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)~=1 then return false end
	if bit.band(typ,4)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_XYZ)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_XYZ)~=1 then return false end
	if bit.band(typ,8)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_LINK)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_LINK)~=1 then return false end
	return true
end
function c9910601.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local onf=LOCATION_MZONE 
	local gra=LOCATION_GRAVE 
	local typ=0
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_FUSION)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_FUSION) then typ=typ+1 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_SYNCHRO)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_SYNCHRO) then typ=typ+2 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_XYZ)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_XYZ) then typ=typ+4 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_LINK)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_LINK) then typ=typ+8 end
	local g=Duel.GetMatchingGroup(c9910601.tgfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and typ>0 and g:CheckSubGroup(c9910601.tgselect,1,4,typ) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910601.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local onf=LOCATION_MZONE 
	local gra=LOCATION_GRAVE 
	local typ=0
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_FUSION)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_FUSION) then typ=typ+1 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_SYNCHRO)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_SYNCHRO) then typ=typ+2 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_XYZ)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_XYZ) then typ=typ+4 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_LINK)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_LINK) then typ=typ+8 end
	local g=Duel.GetMatchingGroup(c9910601.tgfilter,tp,LOCATION_EXTRA,0,nil)
	if typ==0 or g:GetCount()==0 then return end
	local sg=g:SelectSubGroup(tp,c9910601.tgselect,false,1,4,typ)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c9910601.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c9910601.rmfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
		and c:GetAttack()>0 and c:IsAbleToRemoveAsCost()
end
function c9910601.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910601.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910601.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetAttack())
end
function c9910601.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
