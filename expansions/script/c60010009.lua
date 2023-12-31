--尤娜 传说天之镜月
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
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
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)~=0 and Duel.IsPlayerCanDraw(tp) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local num=math.min(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)*5,Duel.GetFlagEffect(tp,60010002))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local bg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,0,0,num,nil)
	if Duel.SendtoDeck(bg,nil,2,REASON_EFFECT) then
		local tb=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK)
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