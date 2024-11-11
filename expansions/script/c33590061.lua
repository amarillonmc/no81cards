local m=33590061
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function Card.GetTypeEffect(c,code)
	local cp={}
	local func=Card.RegisterEffect
	Card.RegisterEffect=function(c,e,f)
		if e:GetCode()==code then
			table.insert(cp,e:Clone())
		end
		return func(c,e,f)
	end
	Duel.CreateToken(0,c:GetOriginalCode())
	Card.RegisterEffect=func
	return cp
end
function table_leng(t)
    local leng=0
    for k,v in pairs(t) do
        leng=leng+1
    end
    return leng
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.filter(c)
	return c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden() and c:IsSetCard(0x4a) and c:IsLevel(10)
end
function cm.filter1(c,ec)
	return c:GetEquipTarget()==ec
end
function cm.filter2(c)
	return c:IsSetCard(0x4a)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if not tc:IsRelateToEffect(e) or g:GetCount()<1 then return end
	Duel.ConfirmCards(tp,g)
	local g2=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_DECK,nil)
	local seq=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if g2:GetCount()>0 and seq>0 then
		local sg=g2:SelectSubGroup(tp,aux.dncheck,false,1,seq)
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	    local ec=sg:GetFirst()
	    while ec do
		    Duel.Equip(tp,ec,tc)
		    --equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(cm.eqlimit)
			ec:RegisterEffect(e1)
			--atk up
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(1000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e2)
			ec=sg:GetNext()
	    end
	    local e6=Effect.CreateEffect(e:GetHandler())
	    e6:SetCategory(CATEGORY_DAMAGE)
	    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	    e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	    e6:SetCountLimit(1)
	    e6:SetRange(LOCATION_MZONE)
	    e6:SetCondition(cm.effcon)
	    e6:SetTarget(cm.damtg)
	    e6:SetCost(cm.effcost)
	    e6:SetOperation(cm.effop)
	    tc:RegisterEffect(e6)
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function cm.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,cm.filter2,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	--local seq=tc:GetSequence()
	Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) 
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local p1,d1=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p1,d1,REASON_EFFECT)
	local tc=e:GetLabelObject()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
	    local ae=tc:GetTypeEffect(EVENT_PHASE+PHASE_BATTLE)
		if table_leng(tc:GetTypeEffect(EVENT_PHASE+PHASE_BATTLE))~=0 then
		    Duel.BreakEffect()
		    local tg=ae[1]:GetTarget()
		    local op=ae[1]:GetOperation()
		    tg(e,tp,eg,ep,ev,re,r,rp)
	        op(e,tp,eg,ep,ev,re,r,rp)
	    end
    end
end