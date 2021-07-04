--升格构造 深红之渊
function c79029809.initial_effect(c)
	--fusion
	aux.AddFusionProcFunFunRep(c,c79029809.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,99,true)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029809.akval)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029809,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029809)
	e2:SetTarget(c79029809.seqtg)
	e2:SetOperation(c79029809.seqop)
	c:RegisterEffect(e2)	 
		if not c79029809.global_check then
		c79029809.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c79029809.checkop)
		Duel.RegisterEffect(ge1,0)
end
end
function c79029809.checkop(e,tp,eg,ep,ev,re,r,rp)
	local xp=re:GetHandlerPlayer()
	local flag=Duel.GetFlagEffectLabel(xp,79029809)
	if flag then
	Duel.SetFlagEffectLabel(xp,79029809,flag+1)
	else
	Duel.RegisterFlagEffect(xp,79029809,0,0,1,1)
	end
end
function c79029809.ffilter(c,fc,sub,mg,sg)
	return c:IsCode(79029808) and c:IsLevelBelow(3)
end
function c79029809.akval(e) 
	local tp=e:GetHandlerPlayer()
	local x=Duel.GetFlagEffectLabel(tp,79029809)
	return e:GetHandler():GetMaterialCount()*100*x
end
function c79029809.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.SetChainLimit(c79029809.chlimit)
end
function c79029809.chlimit(e,ep,tp)
	return tp==ep
end
function c79029809.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	if c:GetSequence()==seq then
		local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(79029809,1)) then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end







