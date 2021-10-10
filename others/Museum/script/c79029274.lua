--星极·时代收藏-寻耀
function c79029274.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c79029274.matfilter,7,2)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029076)
	c:RegisterEffect(e2)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029274.splimit1)
	c:RegisterEffect(e2)	 
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c79029274.lvtg)
	e1:SetValue(c79029274.lvval)
	c:RegisterEffect(e1)
	--0v
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,09029274)
	e2:SetCondition(c79029274.pecon)
	e2:SetTarget(c79029274.petg)
	e2:SetOperation(c79029274.peop)
	c:RegisterEffect(e2)	 
	--dis 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c79029274.cost)
	e2:SetCondition(c79029274.condition)
	e2:SetOperation(c79029274.activate)
	c:RegisterEffect(e2)
	--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c79029274.pencon)
	e5:SetTarget(c79029274.pentg)
	e5:SetOperation(c79029274.penop)
	c:RegisterEffect(e5)
	--l l
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(c79029274.llcon)
	e4:SetOperation(c79029274.llop)
	c:RegisterEffect(e4)
		if not c79029274.global_check then
		c79029274.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c79029274.checkop)
		Duel.RegisterEffect(ge1,0)
end
end
c79029274.pendulum_level=7
function c79029274.matfilter(c)
	return c:IsSetCard(0xa900) and c:IsXyzType(TYPE_PENDULUM)
end
function c79029274.lvtg(e,c)
	return c:IsType(TYPE_XYZ)
end
function c79029274.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return c:GetRank()
	else return lv end
end
function c79029274.checkop(e,tp,eg,ep,ev,re,r,rp)
	local xp=re:GetHandlerPlayer()
	local flag=Duel.GetFlagEffectLabel(xp,79029274)
	if flag then
	Duel.SetFlagEffectLabel(xp,79029274,flag+1)
	else
	Duel.RegisterFlagEffect(xp,79029274,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c79029274.llcon(e,tp,eg,ep,ev,re,r,rp)
	local pp=e:GetHandlerPlayer()
	local ct=Duel.GetFlagEffectLabel(1-pp,79029274) or 0
	return ct~=0
end
function c79029274.llop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029274)
	local ct=Duel.GetFlagEffectLabel(1-tp,79029274) or 0
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-ct*300)
	Debug.Message("悍蛟已至，还想挣脱么。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029274,2))   
end
function c79029274.splimit1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029274.pecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetMaterial():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c79029274.ovfil(c)
	return c:GetSequence()>4
end
function c79029274.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c79029274.petg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029274.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Debug.Message("让我成为众人的星光吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029274,1))   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029274.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,2,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function c79029274.peop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(tp,g)
end
function c79029274.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029274.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and r==REASON_RULE
end
function c79029274.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do 
	if tc:IsLocation(LOCATION_HAND) then
	Duel.ConfirmCards(tp,tc)
	local flag=0
	if tc:IsType(TYPE_MONSTER) then flag=bit.bor(flag,TYPE_MONSTER) end
	if tc:IsType(TYPE_SPELL) then flag=bit.bor(flag,TYPE_SPELL) end
	if tc:IsType(TYPE_TRAP) then flag=bit.bor(flag,TYPE_TRAP) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,flag))
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
	tc=eg:GetNext()
	end
	Debug.Message("这就是，星辰都无法昭示的，“我们”的力量......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029274,3))   
end
end
function c79029274.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c79029274.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c79029274.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Debug.Message("别慌，星极，像平常那样来就行。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029274,4))   
	end
end





