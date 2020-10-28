--个人行动-蝎毒
function c79029335.initial_effect(c)
	c:EnableCounterPermit(0x11)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(c79029335.con)
	e2:SetOperation(c79029335.activate)
	c:RegisterEffect(e2)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1) 
	e2:SetCondition(c79029335.spcon)
	e2:SetOperation(c79029335.spop)
	c:RegisterEffect(e2) 
	--win
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetOperation(c79029335.winop)
	c:RegisterEffect(e7)
		if not c79029335.global_check then
		c79029335.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c79029335.checkop)
		Duel.RegisterEffect(ge1,0)
end 
end
function c79029335.filter(c,e,tp,re)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_COST) and c==re:GetHandler() 
end
function c79029335.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029335.filter,1,nil,e,tp,re)
end
function c79029335.thfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsCode(79029015)
end
function c79029335.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Debug.Message("准备好了......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029335,1))
	local g=Duel.GetMatchingGroup(c79029335.thfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(79029335,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	Debug.Message("别把我丢下......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029335,2))
	end
end
function c79029335.checkop(e,tp,eg,ep,ev,re,r,rp)
	local xp=re:GetHandlerPlayer()
	local flag=Duel.GetFlagEffectLabel(xp,79029335)
	if flag then
	Duel.SetFlagEffectLabel(xp,79029335,flag+1)
	else
	Duel.RegisterFlagEffect(xp,79029335,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c79029335.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(1-tp,79029335) or 0
	return ct>=5
end
function c79029335.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x11,1)
	Debug.Message("为了胜利，我们什么都得做，只是......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029335,3))
end
function c79029335.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_MANTICORE=0x0a
	local c=e:GetHandler()
	if c:GetCounter(0x11)==3 then
	Debug.Message("永别了......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029335,4))
	Duel.Win(tp,WIN_REASON_MANTICORE)
	end
end




