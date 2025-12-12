--灵魂燃烧 连接
local m=70000906
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
end
	function cm.filter(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_MONSTER)
end
	function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	--limit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.checkcon)
	e1:SetOperation(cm.checkop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	Duel.RegisterEffect(e2,tp)
	Duel.Exile(e:GetHandler(),REASON_RULE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	Duel.SendtoGrave(sg,REASON_RULE,tp)
	--tohand
	local tc1=Duel.CreateToken(tp,11962031) 
	local tc2=Duel.CreateToken(tp,28534130)
	Duel.SendtoHand(tc1,tp,REASON_RULE)
	Duel.SendtoHand(tc2,tp,REASON_RULE)
	--toextra
	for i=1,3 do
	local tc3=Duel.CreateToken(tp,87871125) 
	Duel.SendtoDeck(tc3,tp,SEQ_DECKSHUFFLE,REASON_RULE)
	local tc4=Duel.CreateToken(tp,14812471)
	Duel.SendtoDeck(tc4,tp,SEQ_DECKSHUFFLE,REASON_RULE)
end
	local c=e:GetHandler()
	if not (Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)>0)
	then return end
	local d=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	local th=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
	local b2=th and d:IsAbleToHand()
	if d and (b2 or Duel.SelectOption(tp,1153,1190)==0) then
		Duel.MoveToField(d,tp,tp,LOCATION_MZONE,POS_FACEDOWN_DEFENSE,true)
	else
		Duel.SendtoHand(d,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,d)
	end
end
end
	function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
	function cm.chkfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetMaterial():IsExists(Card.IsLink,1,nil,4)
end
	function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.chkfilter,1,nil,tp) then
		--cannot be used as material
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetCondition(cm.checkcon)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsLink,4))
		e1:SetValue(cm.sumlimit)
		Duel.RegisterEffect(e1,tp)
		e:Reset()
	end
end
	function cm.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
	function cm.splimit(e,c)
	return not c:IsSetCard(0x119) and c:IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end