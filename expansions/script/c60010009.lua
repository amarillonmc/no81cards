--尤娜 传说天之镜月
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--MTC.LHini(c)
	MTC.LHSpS(c,3)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	--e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	if not cst==true then
		cst=true
		--local tp=c:GetOwner()
		--spsm
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(cm.LHcon1)
		e1:SetOperation(cm.LHop1)
		Duel.RegisterEffect(e1,0)
		--spsm
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(cm.LHcon1)
		e1:SetOperation(cm.LHop1)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)~=0 and Duel.IsPlayerCanDraw(tp) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local num=math.min(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)*5,Duel.GetFlagEffect(tp,60010002))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local bg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,0,0,num,nil)
	if Duel.SendtoDeck(bg,nil,2,REASON_EFFECT) then
		local tb=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK):GetCount()
		local ti=0
		while tb>=5 do
			tb=tb-5
			ti=ti+1
		end
		if ti~=0 then
			Duel.Draw(tp,ti,REASON_EFFECT)
		end
	end
end
function cm.LHfil1(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0xa621)
end
function cm.LHcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=eg:GetFirst():GetOwner()
	return eg:IsExists(cm.LHfil1,1,nil,tp)
end
function cm.LHop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0xa621) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),60010002,RESET_PHASE+PHASE_END,0,1)
			Duel.RaiseEvent(c,EVENT_CUSTOM+60010002,nil,0,tc:GetSummonPlayer(),tc:GetSummonPlayer(),0)
		end
		tc=eg:GetNext()
	end
end