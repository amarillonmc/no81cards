--吾将远征，鹦鹉螺的大冲角
function c22023460.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c22023460.descon0)
	e2:SetOperation(c22023460.desop0)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023460,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c22023460.descon)
	e3:SetTarget(c22023460.destg)
	e3:SetOperation(c22023460.desop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023460,2))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1)
	e4:SetCondition(c22023460.effcon)
	e4:SetTarget(c22023460.efftg)
	e4:SetOperation(c22023460.effop)
	c:RegisterEffect(e4)
end
function c22023460.descon0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c22023460.desop0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.CheckReleaseGroupEx(tp,Card.IsType,1,REASON_MAINTENANCE,false,nil,TYPE_LINK) and Duel.SelectYesNo(tp,aux.Stringid(22023460,0)) then
		local g=Duel.SelectReleaseGroupEx(tp,Card.IsAttribute,1,1,REASON_MAINTENANCE,false,nil,ATTRIBUTE_WATER)
		Duel.Release(g,REASON_MAINTENANCE)
	else Duel.Destroy(c,REASON_COST) end
end
function c22023460.descon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetBattleMonster(tp)
	if not (ac and ac:IsFaceup() and ac:IsAttribute(ATTRIBUTE_WATER)) then return false end
	local bc=ac:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsControler(1-tp) and bc:IsRelateToBattle()
end
function c22023460.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return bc end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c22023460.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc and bc:IsControler(1-tp) and bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c22023460.scfilter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0xff1) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsControler(tp)
end
function c22023460.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22023460.scfilter,1,nil,tp)
end
function c22023460.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22023460.cfilter1(c)
	return c:IsFaceup() and c:IsCode(22022990)
end
function c22023460.effop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0
		and Duel.IsExistingMatchingCard(c22023460.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.BreakEffect()
		Duel.Recover(tp,2000,REASON_EFFECT)
	end
end