--魔导指挥中心 晶核塔
local cm,m=GetID()
function cm.initial_effect(c)
	if not PNFL_PROPHECY_FLIGHT_CHECK then
		dofile("expansions/script/c11451851.lua")
		pnfl_prophecy_flight_initial(c)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e3)
	--replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.imop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetCondition(function() return not pnfl_adjusting end)
	e5:SetOperation(cm.acop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_CUSTOM+m)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler() or (e:GetCode()==EVENT_CHAINING and rp==1-tp)
end
function cm.filter(c)
	return c:IsSetCard(0x6e) and c:GetType()&0x10002==0x10002 and c:IsFaceup()
end
function cm.refilter(c)
	return c:IsSetCard(0x6e) and c:GetType()&0x10002==0x10002 and c:IsAbleToRemove()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local g2=Duel.GetMatchingGroup(cm.refilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g2:GetClassCount(Card.GetCode)>=3 and #g1<3 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3-#g1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local g2=Duel.GetMatchingGroup(cm.refilter,tp,LOCATION_DECK,0,nil)
	if g2:GetClassCount(Card.GetCode)<3 or #g1>=3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g2:SelectSubGroup(tp,aux.dncheck,false,3,3)
	if sg then
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		if #g1>0 then
			sg=sg:Select(1-tp,3-#g1,3-#g1,nil)
		end
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if #g1==3 then
		g1=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
	end
end
function cm.filter1(c)
	local eset={c:IsHasEffect(0x20000000+m)}
	if #eset>0 then return eset[1]:GetLabelObject() end
	return false
end
function cm.imop(e,te)
	if te and te:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then
		if te:GetHandler():IsLocation(LOCATION_DECK) then
			local e1=te:GetHandler():RegisterFlagEffect(11451858,RESET_EVENT+RESETS_STANDARD,0,1)
			e1:SetLabelObject(te)
		end
	end
	return false
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	pnfl_adjusting=true
	local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
	for tc in aux.Next(g) do
		Duel.RaiseEvent(tc,EVENT_CUSTOM+m,cm.filter1(tc),0,0,0,0)
		tc:ResetFlagEffect(m)
	end
	pnfl_adjusting=false
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsControler(tp) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,1)) then
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local te1=re:Clone()
			if re:GetOwner():GetOriginalCode()==11451851 then te1=c11451851.highground:Clone() end
			te1:SetDescription(aux.Stringid(m,2))
			te1:SetProperty(te1:GetProperty()|EFFECT_FLAG_CLIENT_HINT)
			te1:SetRange(LOCATION_MZONE)
			te1:SetCondition(aux.TRUE)
			te1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(te1,true)
			Duel.SpecialSummonComplete()
		end
	end
end