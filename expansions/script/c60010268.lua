--百识·印
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010261)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+10000000)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetCode()==60010261 then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,0,0,1)
		end
		tc=eg:GetNext()
	end
end
function cm.filter(c)
	return c:IsCode(60010261) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local op=aux.SelectFromOptions(tp,{true,aux.Stringid(m,1)},{true,aux.Stringid(m,2)},{true,aux.Stringid(m,3)},{true,aux.Stringid(m,4)})
	local code=60010261+op
	local token=Duel.CreateToken(tp,code)
	if Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			local tc=Duel.GetOperatedGroup():GetFirst()
			Duel.ConfirmCards(1-tp,g)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsSummonable(true,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e1:SetRange(0xff)
				e1:SetValue(token:GetAttribute())
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				tc:RegisterEffect(e1)
				Duel.Summon(tp,tc,true,nil)
			end
		end
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=Duel.GetFlagEffect(tp,m)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,num) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(num)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,num)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
