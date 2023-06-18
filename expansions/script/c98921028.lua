--魔神仪-未知药水
function c98921028.initial_effect(c)
	c:EnableReviveLimit()
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921028,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98921028)
	e1:SetCost(c98921028.cost)
	e1:SetTarget(c98921028.sptg)
	e1:SetOperation(c98921028.spop)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98921028,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98921028.con)
	e3:SetTarget(c98921028.tktg)
	e3:SetOperation(c98921028.tkop)
	c:RegisterEffect(e3)
end
c98921028.toss_coin=true
function c98921028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c98921028.spfilter(c,e,tp)
	return c:IsSetCard(0x117) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98921028.costfilter(c,e,tp,mg,rlv,mc)
	if not (c:IsLevelAbove(0) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and not c:IsPublic()) then return false end
	return mg:CheckSubGroup(c98921028.fselect,1,c:GetLevel(),tp,c:GetLevel(),mc)
end
function c98921028.fselect(g,tp,lv,mc)
	local mg=g:Clone()
	if Duel.GetMZoneCount(tp)>0 then
		 Duel.SetSelectedCard(g)
		 return aux.dncheck(g) and g:CheckWithSumGreater(Card.GetOriginalLevel,lv)
	else return false end
end
function c98921028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c98921028.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then 
	   if e:GetLabel()~=100 then return false end
	   e:SetLabel(0) 
	   if mg:GetCount()==0 then return false end
	   return Duel.IsExistingMatchingCard(c98921028.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
	end
	e:SetLabel(0)
	Duel.SendtoGrave(c,REASON_DISCARD+REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c98921028.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,c:GetOriginalLevel(),c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98921028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(c98921028.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if mg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=mg:SelectSubGroup(tp,c98921028.fselect,false,1,tc:GetLevel(),tp,tc:GetLevel(),c)
		if g and g:GetCount()>0 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local og=Duel.GetOperatedGroup()
				local lv=og:GetSum(Card.GetLevel)
				local lp=Duel.GetLP(tp)
				Duel.BreakEffect()
				Duel.SetLP(tp,lp-lv*300)
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98921028.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c98921028.con(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function c98921028.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c98921028.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c98921028.tkop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if res==1 then ct=500
	else ct=-500 end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct)
		tc:RegisterEffect(e1)
	end
end