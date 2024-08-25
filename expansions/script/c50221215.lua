--数码兽的连接
function c50221215.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c50221215.target)
	e1:SetOperation(c50221215.activate)
	c:RegisterEffect(e1)
	--avoid damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c50221215.adcon)
	e2:SetOperation(c50221215.adop)
	c:RegisterEffect(e2)
end
function c50221215.tdfilter(c,e,tp)
	return c:IsSetCard(0xcb1) and c:IsLevelAbove(1) and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c50221215.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode(),c:GetLevel())
end
function c50221215.spfilter(c,e,tp,code,lv)
	return c:IsSetCard(0xcb1) and not c:IsCode(code) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c50221215.target(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0,0)
	local check,code,lv=e:GetLabel()
	if chk==0 then
		if check~=100 then return false end
		e:SetLabel(0,0,0)
		return Duel.IsExistingMatchingCard(c50221215.tdfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50221215.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c50221215.tdfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	e:SetLabel(0,tc:GetCode(),tc:GetLevel())
	local c=e:GetHandler()
	local check,code,lv=e:GetLabel()	
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c50221215.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code,lv)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function c50221215.adcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and aux.nzatk(Duel.GetAttacker())
end
function c50221215.adop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end