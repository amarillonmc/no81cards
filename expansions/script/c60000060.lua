local m=60000060
local cm=_G["c"..m]
cm.name="永夜与黄昏相伴"
function cm.initial_effect(c)
	c:SetSPSummonOnce(60000060)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x62a),5,true)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.fspcon)
	e1:SetOperation(cm.fspop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	--cannot be destroyed
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.incon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	if not cm.battle_check then
		cm.battle_check=true
		cm.battle_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_BATTLED)
		ge2:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.check(c)
	return c and c:IsSetCard(0x62a)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if cm.check(Duel.GetAttacker()) or cm.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0x62a) and c:IsAbleToGraveAsCost()
end
function cm.fspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
	and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,tp) 
		and Duel.GetFlagEffect(tp,m)>=3
end
function cm.fspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.incon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)>=15
end
function cm.spfilter3(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x62a)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter3,1,nil,tp)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
