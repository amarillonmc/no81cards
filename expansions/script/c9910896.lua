--逆反的机械达人
function c9910896.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910896)
	e1:SetTarget(c9910896.destg)
	e1:SetOperation(c9910896.desop)
	c:RegisterEffect(e1)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910896,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9910897)
	e2:SetTarget(c9910896.sptg)
	e2:SetOperation(c9910896.spop)
	c:RegisterEffect(e2)
	--add race
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c9910896.racon)
	e3:SetOperation(c9910896.raop)
	c:RegisterEffect(e3)
end
function c9910896.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SPELL+TYPE_TRAP)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,0,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910896.thfilter(c)
	return aux.IsCodeListed(c,9910871) and c:IsAbleToHand()
end
function c9910896.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then g:AddCard(tc) end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 then g:Merge(Duel.GetDecktopGroup(tp,4)) end
	if g:GetCount()==0 or Duel.Destroy(g,REASON_EFFECT)==0 then return end
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910896.thfilter),tp,LOCATION_GRAVE,0,nil)
	if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910896,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=tg:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9910896.spfilter(c,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(c9910896.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c9910896.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2) and c:IsRace(RACE_MACHINE)
end
function c9910896.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910896.spfilter(chkc,tp,c) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c9910896.spfilter,tp,LOCATION_MZONE,0,1,nil,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910896.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_EXTRA)
end
function c9910896.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local race=tc:GetRace()
	Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	local mg=Group.FromCards(c,tc)
	if mg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c9910896.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		c:RegisterFlagEffect(9910896,0,0,1,race)
		Duel.XyzSummon(tp,sc,mg)
	end
end
function c9910896.racon(e,tp,eg,ep,ev,re,r,rp)
	local race=e:GetHandler():GetFlagEffectLabel(9910896)
	return r==REASON_XYZ and race and race>0
end
function c9910896.raop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local race=c:GetFlagEffectLabel(9910896)
	c:ResetFlagEffect(9910896)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetValue(race)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
