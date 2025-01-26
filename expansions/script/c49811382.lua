--ガーディアンのシャンセル
local cm,m=GetID()

function cm.initial_effect(c)
    aux.AddCodeList(c,34022290)
	--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
	e1:SetTarget(cm.setg)
	e1:SetOperation(cm.seop)
	c:RegisterEffect(e1)
    --cannot be target
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_FZONE)
	e0:SetTargetRange(0x0c,0)
	e0:SetTarget(cm.target)
	e0:SetValue(aux.tgoval)
	c:RegisterEffect(e0)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(0x0c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(cm.efilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(0x100)
	e3:SetTargetRange(0x0c,0)
	e3:SetTarget(cm.eftg2)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
    --spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1,m+1)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(cm.efftg)
	e5:SetOperation(cm.effop)
	c:RegisterEffect(e5)
    --inactivatable
	local ge4=Effect.CreateEffect(c)
	ge4:SetType(EFFECT_TYPE_FIELD)
	ge4:SetCode(EFFECT_CANNOT_INACTIVATE)
    ge4:SetCondition(cm.actcon)
	ge4:SetValue(cm.effectfilter)
	Duel.RegisterEffect(ge4,0)
	local ge5=ge4:Clone()
	ge5:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(ge5,0)
end

function cm.target(e,c)
	return (c:IsSetCard(0x52) and c:IsLocation(0x04)) or c:GetType()==0x40002
end

function cm.eftg2(e,c)
	return cm.target(e,c) and c:IsFaceup()
end

function cm.efilter(e,c,rp,r,re)
	return c==e:GetHandler() and r&REASON_EFFECT~=0
end

function cm.tgsfilter(c)
    return (aux.IsCodeListed(c,34022290) or c:IsCode(55569674)) and c:IsAbleToHand()
end

function cm.tgsfilter2(c)
    return c:IsCode(34022290) and c:IsAbleToHand()
end

function cm.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x11,0,1,nil) and Duel.IsExistingMatchingCard(cm.tgsfilter2,tp,0x11,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,0x11)
end

function cm.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgsfilter2,tp,0x11,0,1,1,nil)
	if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	    local g1=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x11,0,1,1,nil)
        if #g1>0 then
            g:Merge(g1)
        end
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function cm.tgefilter(c)
    return c:IsPublic() and c:IsSetCard(0x52) and c:IsType(0x1)
end

function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgefilter,tp,0x02,0,1,nil) end
end

function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgefilter,tp,0x02,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		g=g:SelectSubGroup(tp,aux.dncheck,false,1,#g)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			g:KeepAlive()
			--effect gain
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_ADJUST)
			e2:SetReset(RESET_PHASE+PHASE_END,2)
			e2:SetLabelObject(g)
			e2:SetCondition(cm.effcon)
			e2:SetOperation(cm.effop2)
			Duel.RegisterEffect(e2,tp)
			--eff gain of battlecry
			local e3=e2:Clone()
			e3:SetCondition(cm.effcon3)
			e3:SetOperation(cm.effop3)
			Duel.RegisterEffect(e3,tp)
		end
	end
end

function cm.conefilter(c)
	return c:IsFaceup() and c:IsCode(34022290) and c:GetFlagEffect(m)==0
end

function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.conefilter,tp,0x04,0,1,nil)
end

function cm.effop2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(Duel.GetMatchingGroup(cm.conefilter,tp,0x04,0,nil)) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		for cc in aux.Next(e:GetLabelObject()) do
				local code=cc:GetOriginalCode()
				local e2=Effect.CreateEffect(tc)
				e2:SetDescription(aux.Stringid(34022290,1))
				e2:SetCategory(CATEGORY_REMOVE)
				e2:SetType(EFFECT_TYPE_QUICK_O)
				e2:SetCode(EVENT_FREE_CHAIN)
				e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
				e2:SetRange(LOCATION_MZONE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e2:SetCost(cm.rmcost)
				e2:SetTarget(cm.rmtg)
				e2:SetOperation(cm.rmop)
				tc:RegisterEffect(e2)
			if code==34022290 then
				local e2=Effect.CreateEffect(tc)
				e2:SetDescription(aux.Stringid(34022290,1))
				e2:SetCategory(CATEGORY_REMOVE)
				e2:SetType(EFFECT_TYPE_QUICK_O)
				e2:SetCode(EVENT_FREE_CHAIN)
				e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
				e2:SetRange(LOCATION_MZONE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e2:SetCost(cm.rmcost)
				e2:SetTarget(cm.rmtg)
				e2:SetOperation(cm.rmop)
				tc:RegisterEffect(e2)
			elseif code==10755153 then
				local e4=Effect.CreateEffect(tc)
				e4:SetDescription(aux.Stringid(10755153,0))
				e4:SetCategory(CATEGORY_DESTROY)
				e4:SetType(EFFECT_TYPE_QUICK_O)
				e4:SetCode(EVENT_FREE_CHAIN)
				e4:SetRange(LOCATION_MZONE)
				e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e4:SetCost(cm.descost)
				e4:SetTarget(cm.destg)
				e4:SetOperation(cm.desop)
				tc:RegisterEffect(e4)
			else
				tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			end
		end
	end
end

function cm.conefilter3(c)
	return c:IsCode(34022290) and c:GetFlagEffect(m+1)==0
end

function cm.effcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.conefilter3,tp,0xff,0,1,nil)
end

function cm.effop3(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(Duel.GetMatchingGroup(cm.conefilter3,tp,0xff,0,nil)) do
		tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
		local cregister=Card.RegisterEffect
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:IsHasType(EFFECT_TYPE_SINGLE) and (effect:GetCode()==EVENT_SUMMON_SUCCESS or effect:GetCode()==EVENT_SPSUMMON_SUCCESS) then
				return cregister(card,effect,flag)
			end
			return 
		end
		for cc in aux.Next(e:GetLabelObject()) do
			local code=cc:GetOriginalCode()
			tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		end
		Card.RegisterEffect=cregister
	end
end

function cm.actcon(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandler():GetControler(),0x10,0,nil,0x1)==0
end

function cm.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler() and te:IsActivated()
end

--穷举用func
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(cm.cfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,cm.cfilter,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,0,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.costfilter(c,ec)
	return c:IsFaceup() and c:GetEquipTarget()==ec and c:IsAbleToGraveAsCost()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_SZONE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_SZONE,0,1,1,nil,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end