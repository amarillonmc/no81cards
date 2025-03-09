--百千抉择的护卫 鲁菲娜
function c67201135.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201135,10))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	--e1:SetCountLimit(1,67201135)
	e1:SetTarget(c67201135.optg1)
	e1:SetOperation(c67201135.opop1)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201135,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CUSTOM+67201135)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,67201135)
	e3:SetCondition(c67201135.opcon)
	e3:SetTarget(c67201135.optg)
	e3:SetOperation(c67201135.opop)
	c:RegisterEffect(e3) 
	if not c67201135.global_check then
		c67201135.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c67201135.regcon)
		ge1:SetOperation(c67201135.regop)
		Duel.RegisterEffect(ge1,0)
	end  
end
function c67201135.regfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c67201135.regcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==0 then return false end
	local v=0
	if eg:IsExists(c67201135.regfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c67201135.regfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c67201135.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+67201135,re,r,rp,ep,e:GetLabel())
end
--
--
function c67201135.spfilter(c,e,tp)
	return c:IsSetCard(0x3670) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67201135.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3670)
end
function c67201135.lkfilter(c,mg)
	return c:IsLinkSummonable(mg)
end
function c67201135.optg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local mg=Duel.GetMatchingGroup(c67201135.matfilter,tp,LOCATION_MZONE,0,nil)
	local b2=Duel.IsExistingMatchingCard(c67201135.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	if chk==0 then return b1 or b2 end
end
function c67201135.opop1(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local mg=Duel.GetMatchingGroup(c67201135.matfilter,tp,LOCATION_MZONE,0,nil)
	local b2=Duel.IsExistingMatchingCard(c67201135.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201135,8),aux.Stringid(67201135,9))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201135,8))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201135,9))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		--local mg=Duel.GetMatchingGroup(c67201135.matfilter,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c67201135.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local tc=tg:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,mg)
		end
	end
end

--
function c67201135.opcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==PLAYER_ALL or ev==tp or ev==1-tp
end
function c67201135.filter2(c)
	return c:IsAbleToDeck()
end
function c67201135.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsAbleToDeck()
	if chk==0 then return b1 or b2 end
end
function c67201135.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsAbleToDeck()
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201135,1),aux.Stringid(67201135,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201135,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201135,2))+1
	else return end
	if op==0 then
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		if not c:IsRelateToEffect(e) then return end
		local opt=Duel.SelectOption(tp,aux.Stringid(67201135,5),aux.Stringid(67201135,6))
		if opt==0 then
			Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
		local gg=Duel.GetOperatedGroup()
		if gg:GetCount()>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(67201135,4)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

