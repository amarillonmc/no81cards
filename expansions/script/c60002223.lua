--机锋的罪人 卡特斯罗特
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetOperation(cm.op0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(cm.cos5)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
end
--e0
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFieldID()<=172 then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
end
--e1
function cm.con1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c:GetFlagEffect(m)>0
end
--e2
function cm.con2(e,c,minc)
	if c==nil then return true end
	return minc<=1 and Duel.CheckTribute(c,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c)
	g=Duel.SelectTribute(tp,c,1,Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE))
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	for tc in aux.Next(g) do
		if tc:IsLocation(LOCATION_GRAVE) then 
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
--e3
function cm.op3f1(c,mc)
	return not aux.IsCodeListed(c,mc:GetCode())
end
function cm.op3con1f(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and (c:IsReason(REASON_COST) or c:IsReason(REASON_SUMMON+REASON_MATERIAL))
end
function cm.op3con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.op3con1f,1,nil,tp)
end
function cm.op3op1(e,tp,eg,ep,ev,re,r,rp)
	if #eg-1<=0 then return end
	Duel.Draw(tp,#eg-1,REASON_EFFECT)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c,g=e:GetHandler(),Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	Duel.ConfirmCards(1-tp,g)
	g=g:Filter(cm.op3f1,nil,c)
	if g:GetClassCount(Card.GetCode)==#g then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_RELEASE)
		e1:SetCondition(cm.op3con1)
		e1:SetOperation(cm.op3op1)
		Duel.RegisterEffect(e1,tp)
	end
end
--e5
function cm.cos5f1(c)
	return c:GetFlagEffect(m)>0 and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function cm.cos5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cos5f1,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cos5f1,tp,LOCATION_GRAVE,0,2,99,nil)
	e:SetLabel(Duel.SendtoDeck(g,tp,2,REASON_COST))
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local dam=e:GetLabel()>2 and 4000 or 2000
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetLabel()>2 and 4000 or 2000
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsFaceup() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(dam)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e:GetHandler():RegisterEffect(e1)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
