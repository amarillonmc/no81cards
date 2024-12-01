local m=11223434
local cm=_G["c"..m]
cm.name="暗斗神 灵角"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon
	aux.AddXyzProcedure(c,cm.xfilter,4,2)
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
	--Reflect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.cost)
	e3:SetOperation(cm.operation)
	e3:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e3)
end
--Xyz Summon
function cm.xfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
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
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e0:SetCode(EVENT_DESTROYED)
		e0:SetRange(LOCATION_MZONE)
		e0:SetCountLimit(1)
		e0:SetCost(cm.copycost)
		e0:SetCondition(cm.copycon)
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
function cm.copycon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and eg:GetCount()==1 and tc:GetBaseAttack()==500 and tc:IsReason(REASON_EFFECT)
		and tc:IsPreviousLocation(LOCATION_MZONE) and tc:GetPreviousControler()==tp
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsAbleToHand() end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
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

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end