local m=11223433
local cm=_G["c"..m]
cm.name="邪斗神 逆牙"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon
	aux.AddSynchroProcedure(c,cm.tfilter,aux.NonTuner(cm.ntfilter),1)
	--Extra Effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(cm.con)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	--Material Check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.valcheck)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
--Synchro Summon
function cm.tfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.ntfilter(c)
	return c:IsRace(RACE_WARRIOR)
end
--Material Check
function cm.cfilter(c)
	return c:GetBaseAttack()==500 and c:GetBaseDefense()==500
end
function cm.valcheck(e,c)
	if c:GetMaterial():IsExists(cm.cfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	end
end
--Copy
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	local c=e:GetHandler()
	if c:IsFaceup() then
		--Copy
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(m,0))
		e0:SetCategory(CATEGORY_TOHAND)
		e0:SetType(EFFECT_TYPE_IGNITION)
		e0:SetRange(LOCATION_MZONE)
		e0:SetCountLimit(1)
		e0:SetCost(cm.copycost)
		e0:SetTarget(cm.copytg)
		e0:SetOperation(cm.copyop)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e0)
	end
end
function cm.copyfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()==500 and c:IsAbleToHand()
end
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.copyfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.copyfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.copyfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=tg:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local c=e:GetHandler()
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.rstop)
		e1:SetLabel(cid)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
--Equip
function cm.filter(c)
	return c:GetLevel()==4 and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local tc=sg:GetFirst()
		while tc do
			if Duel.Equip(tp,tc,c,false) then
				local atk=tc:GetBaseAttack()
				--Add Equip Limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetValue(cm.eqlimit)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				if atk>0 then
					--Atk Up
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_EQUIP)
					e2:SetCode(EFFECT_UPDATE_ATTACK)
					e2:SetValue(atk)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e2)
				end
			end
			tc=sg:GetNext()
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		tc=sg:Select(tp,1,1,nil):GetFirst()
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.rstop)
		e1:SetLabel(cid)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end