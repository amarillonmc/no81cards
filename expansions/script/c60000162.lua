--铸星机魂
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000150)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsCode(60000157) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(60000150)
end
function cm.gfilter(c)
	return c:IsCode(60000154,60000155,60000156,60000160,60000161) and c:IsAbleToGrave()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.gfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup() 
		or not Duel.IsExistingMatchingCard(cm.gfilter,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.gfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local fc=Duel.GetOperatedGroup():GetFirst()
		if fc:GetCode()==60000154 then
			fc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(800)
			fc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			fc:RegisterEffect(e2)
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(60000154,2))
			e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TODECK)
			e4:SetType(EFFECT_TYPE_QUICK_O)
			e4:SetCode(EVENT_FREE_CHAIN)
			e4:SetRange(LOCATION_MZONE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetCountLimit(1,60000154)
			e4:SetTarget(cm.eqtg1)
			e4:SetOperation(cm.eqop1)
			fc:RegisterEffect(e4)
			
		elseif fc:GetCode()==60000155 then
			fc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(800)
			fc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			fc:RegisterEffect(e2)
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(60000155,2))
			e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH)
			e4:SetType(EFFECT_TYPE_QUICK_O)
			e4:SetCode(EVENT_FREE_CHAIN)
			e4:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetCountLimit(1,60000155)
			e4:SetTarget(cm.eqtg2)
			e4:SetOperation(cm.eqop2)
			fc:RegisterEffect(e4)
			
		elseif fc:GetCode()==60000156 then
			fc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(cm.val1)
			fc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			fc:RegisterEffect(e2)
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(60000156,2))
			e4:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
			e4:SetType(EFFECT_TYPE_QUICK_O)
			e4:SetCode(EVENT_FREE_CHAIN)
			e4:SetRange(LOCATION_MZONE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetCountLimit(1,60000156)
			e4:SetTarget(cm.eqtg3)
			e4:SetOperation(cm.eqop3)
			fc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetCode(EVENT_BECOME_TARGET)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e5:SetOperation(cm.eqop4)
			fc:RegisterEffect(e5)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e3:SetReset(RESET_PHASE+PHASE_END)
			e3:SetTarget(cm.eftg4)
			e3:SetValue(1)
			Duel.RegisterEffect(e3,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetDescription(aux.Stringid(60000156,3))
			e6:SetCategory(CATEGORY_EQUIP)
			e6:SetType(EFFECT_TYPE_QUICK_O)
			e6:SetCode(EVENT_FREE_CHAIN)
			e6:SetRange(LOCATION_MZONE)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e6:SetCountLimit(1,70000156)
			e6:SetCondition(cm.eqcon5)
			e6:SetTarget(cm.eqtg5)
			e6:SetOperation(cm.eqop5)
			fc:RegisterEffect(e6)
			
		elseif fc:GetCode()==60000160 then
			fc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(cm.val2)
			fc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			fc:RegisterEffect(e2)
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(60000160,2))
			e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
			e4:SetType(EFFECT_TYPE_QUICK_O)
			e4:SetCode(EVENT_FREE_CHAIN)
			e4:SetRange(LOCATION_MZONE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetCountLimit(1,60000160)
			e4:SetCost(cm.eqcost6)
			e4:SetTarget(cm.eqtg6)
			e4:SetOperation(cm.eqop6)
			fc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetCode(EVENT_BECOME_TARGET)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e5:SetOperation(cm.eqop7)
			fc:RegisterEffect(e5)
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_PIERCE)
			e7:SetValue(DOUBLE_DAMAGE)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			fc:RegisterEffect(e7)
			local e6=Effect.CreateEffect(c)
			e6:SetDescription(aux.Stringid(60000160,3))
			e6:SetCategory(CATEGORY_EQUIP)
			e6:SetType(EFFECT_TYPE_QUICK_O)
			e6:SetCode(EVENT_FREE_CHAIN)
			e6:SetRange(LOCATION_MZONE)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e6:SetCountLimit(1,70000160)
			e6:SetTarget(cm.eqtg8)
			e6:SetOperation(cm.eqop8)
			fc:RegisterEffect(e7)

		elseif fc:GetCode()==60000161 then
			fc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(800)
			fc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			fc:RegisterEffect(e2)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetCode(60000158)
			e2:SetTargetRange(1,0)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.eqfil1(c)
	return c:IsFaceup() and not (c:IsAttack(0) and c:IsDefense(0))
end
function cm.eqfil2(c)
	return aux.IsCodeListed(c,60000150) and c:IsAbleToDeck()
end
function cm.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.eqfil1,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(cm.eqfil2,tp,LOCATION_GRAVE,0,num,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
end
function cm.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if not Duel.IsExistingMatchingCard(cm.eqfil2,tp,LOCATION_GRAVE,0,num,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.eqfil2,tp,LOCATION_GRAVE,0,num,num,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		for tc in aux.Next(mg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e2)
		end
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ATTACK_ALL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e3)
	end
end
function cm.eqfil3(c)
	return aux.IsCodeListed(c,60000150) and c:IsAbleToHand()
end
function cm.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.eqfil3,tp,LOCATION_DECK,0,1,nil)
		and e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0
		and tc:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,3))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
			tc:RegisterFlagEffect(60000155,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
			tc:RegisterFlagEffect(60000155,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
		end
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.eqfil3,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffect(60000155)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end

function cm.val1(e,c)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),60000156)*300
end
function cm.eqtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,60000156)>=2 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.eqop3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	end
end
function cm.eqop4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,60000156)<3 then return end
	Duel.Hint(HINT_CARD,0,60000156)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.eftg4(e,c)
	local tc=c:GetEquipTarget()
	return tc and tc:GetEquipGroup():IsContains(c) and Duel.GetFlagEffect(e:GetHandlerPlayer(),60000156)>=4
end
function cm.eqcon5(e,tp,eg,ep,ev,re,r,rp)
	return #e:GetHandler():GetEquipGroup()<3
end
function cm.eqtg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=3-#e:GetHandler():GetEquipGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.eqfil5,tp,LOCATION_DECK+LOCATION_GRAVE,0,num,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>=num
		and Duel.GetFlagEffect(e:GetHandlerPlayer(),60000156)>=5 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.eqop5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=3-#e:GetHandler():GetEquipGroup()
	if Duel.IsExistingMatchingCard(cm.eqfil5,tp,LOCATION_DECK+LOCATION_GRAVE,0,num,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>=num then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eg=Duel.SelectMatchingCard(tp,cm.eqfil5,tp,LOCATION_DECK+LOCATION_GRAVE,0,num,num,nil)
		for ec in aux.Next(eg) do
			if Duel.Equip(tp,ec,c,true) then
				local e1=Effect.CreateEffect(ec)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetLabelObject(c)
				e1:SetValue(cm.teqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				ec:RegisterEffect(e1)
			end
		end
		Duel.EquipComplete()
	end
end
function cm.teqlimit(e,c)
	return e:GetLabelObject()==c
end
function cm.val2(e,c)
	if Duel.GetFlagEffect(e:GetHandlerPlayer(),60000160)>=3 then
		return Duel.GetFlagEffect(e:GetHandlerPlayer(),60000160)*100
	else return 0 end
end
function cm.eqcost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=math.floor(Duel.GetLP(e:GetHandlerPlayer())/2)
	Duel.PayLPCost(e:GetHandlerPlayer(),num)
	e:SetLabel(num)
end
function cm.eqtg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetFlagEffect(e:GetHandlerPlayer(),60000160)>=6 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function cm.eqop6(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then return end
	local lp=e:GetLabel()
	local num=0
	while lp>=800 do
		num=num+1
		lp=lp-800
	end
	local dg=Duel.GetDecktopGroup(tp,num)
	Duel.ConfirmDecktop(tp,num)
	Duel.SendtoHand(dg:Filter(cm.egfil6,nil),nil,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(hg,nil,1,REASON_EFFECT)
end
function cm.egfil6(c)
	return (aux.IsCodeListed(c,60000150) or c:IsType(TYPE_EQUIP)) and c:IsAbleToHand()
end
function cm.eqop7(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(e:GetHandlerPlayer(),60000160)<9 then return end
	Duel.Hint(HINT_CARD,0,60000160)
	Duel.Recover(tp,800,REASON_EFFECT)
end
function cm.eqtg8(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(e:GetHandlerPlayer(),60000160)>=15 end
end
function cm.eqop8(e,tp,eg,ep,ev,re,r,rp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(cm.negop)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp) 
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetControler()~=tp and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_CARD,0,60000160)
		Duel.NegateEffect(ev)
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		e:Reset()
	end
end































