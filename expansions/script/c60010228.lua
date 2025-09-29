--青雀-棋枰作枕-
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	MTC.AvatarCreate(c,m+1,LOCATION_MZONE)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,1))
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_CUSTOM+60010225)
	e11:SetRange(LOCATION_MZONE)
	e11:SetOperation(cm.cgop)
	c:RegisterEffect(e11)
end
function cm.thfilter(c)
	return c:IsCode(60010228) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=math.min(Duel.GetFlagEffect(tp,60010228)+2,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<num then return false end
		local g=Duel.GetDecktopGroup(tp,num)
		local result=g:FilterCount(Card.IsAbleToGrave,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local num=math.min(Duel.GetFlagEffect(tp,60010228)+2,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	local u=1
	if num>=5 then u=2 end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,num)
	local g=Duel.GetDecktopGroup(p,num)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local sg=g:Select(p,1,u,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
		Duel.ShuffleDeck(p)
	end
end
function cm.cgop(e,tp,eg,ep,ev,re,r,rp)
	local num=4
	if Duel.IsPlayerAffectedByEffect(tp,60010228) then num=8 end
	e:GetHandler():AddCounter(0x62a,num)
end